import json
import subprocess
import tempfile
from pathlib import Path

from tex2typ.equation_converter import EquationConverter as NSJTex2TypEquationConverter

_THIS_FILE = Path(__file__).resolve()
_PROJECT_DIR = _THIS_FILE.parent.parent
_VENDORED_DIR = _PROJECT_DIR / "vendored"

_NSJ_CONVERTER = NSJTex2TypEquationConverter()
_PARANEXUS_TEX2TYP_DIR = _VENDORED_DIR / "tex2typ"
_MITEX_WASM_DIR = _VENDORED_DIR / "mitex-wasm"


def latex_to_typst_nsj_tex2typ(latex_expression: str) -> str:
    """
    Converts LaTeX to Typst using tex2typ by Niels Skovgaard Jensen.

    Converter: https://pypi.org/project/tex2typ/

    Arguments:
        latex_expression (str): LaTeX expression to convert.

    Returns:
        str: Converted Typst expression.
    """
    typst_expression = _NSJ_CONVERTER.convert(latex_expression)
    return typst_expression


def latex_to_typst_paranexus_tex2typ(latex_expression: str) -> str:
    """
    Convert LaTeX expression to Typst using paranexus tex2typ tool.

    See: https://github.com/paran3xus/tex2typ/tree/398ca4bd70dcc276e283de79dbc3bc1e203d73fc

    Uses stdin/stdout for communication with the Node.js script.

    Arguments:
        latex_expression (str): LaTeX expression to convert.
    Returns:
        str: Converted Typst expression.
    """
    result = subprocess.run(
        ["node", "index.js", "stdin"],
        input=latex_expression,
        capture_output=True,
        text=True,
        cwd=_PARANEXUS_TEX2TYP_DIR,
    )

    if result.returncode != 0:
        raise RuntimeError(f"tex2typ conversion failed: {result.stderr}")

    return result.stdout.strip()


def latex_to_typst_paranexus_tex2typ_batch(latex_expressions: list[str]) -> list[str]:
    """
    Convert a batch of LaTeX expressions to Typst using paranexus tex2typ tool.

    See: https://github.com/paran3xus/tex2typ/tree/398ca4bd70dcc276e283de79dbc3bc1e203d73fc
    Uses stdin/stdout for communication with the Node.js script.
    Arguments:
        latex_expressions (list[str]): List of LaTeX expressions to convert.
    Returns:
        list[str]: List of converted Typst expressions.
    """
    input_data_json = json.dumps(latex_expressions)
    result = subprocess.run(
        ["node", "index.js", "stdin-json"],
        input=input_data_json,
        capture_output=True,
        text=True,
        encoding="utf-8",
        cwd=_PARANEXUS_TEX2TYP_DIR,
    )

    if result.returncode != 0:
        raise RuntimeError(f"tex2typ batch conversion failed: {result.stderr}")

    output_data = result.stdout.strip()
    typst_expressions = json.loads(output_data)
    return typst_expressions


def latex_to_typst_mitex(latex_expression: str) -> str:
    """
    Convert LaTeX expression to Typst using MiTeX and typstyle.

    Requires MiTeX to be installed.

    Arguments:
        latex_expression (str): LaTeX expression to convert.

    Returns:
        str: Converted Typst expression.
    """
    # MiTeX command requires a file input, so we make one
    with tempfile.NamedTemporaryFile(mode="w", suffix=".tex", delete=False) as f:
        # filename =
        f.write(latex_expression)
        f.flush()
        result = subprocess.run(
            ["mitex", "compile", "--stage", "document", f.name],
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise RuntimeError(f"MiTeX conversion failed: {result.stderr}")
        return result.stdout


def latex_to_typst_mitex_wasm(latex_expression: str) -> str:
    """
    Convert LaTeX expression to Typst using MiTeX WASM build.

    Uses the WebAssembly build via Node.js for cross-platform compatibility.

    Arguments:
        latex_expression (str): LaTeX expression to convert.
    Returns:
        str: Converted Typst expression.
    """

    result = subprocess.run(
        ["node", "mitex_wasm_wrapper.js"],
        input=latex_expression,
        capture_output=True,
        text=True,
        cwd=_MITEX_WASM_DIR,
    )

    if result.returncode != 0:
        raise RuntimeError(f"MiTeX WASM conversion failed: {result.stderr}")

    return result.stdout.strip()


def typstyle(typst_expression: str) -> str:
    """
    Runs the typstyle formatter on a Typst expression.

    Arguments:
        typst_expression (str): Typst expression to format.
    Returns:
        str: Formatted Typst expression.
    """
    result = subprocess.run(
        ["typstyle"],
        input=typst_expression,
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        raise RuntimeError(f"Typstyle conversion failed: {result.stderr}")

    return result.stdout.strip()
