import typst
from PIL import Image as image
from io import BytesIO

_TYPST_TEMPLATE = """
#set page(width: auto, height: auto, margin: 0pt)
$
{typst_code}
$
"""


class TypstGrayscaleCompiler:
    def __init__(self, template: str = _TYPST_TEMPLATE, ppi: float = 144.0):
        self.ppi = ppi

        self.compiler = typst.Compiler()

    def compile(self, typst_code: str) -> image.Image:
        """
        Renders Typst code to a cropped grayscale PNG image.
        Cropping is taken care of by Typst's auto page sizing.

        Args:
            typst_code: The Typst code to render.

        Returns:
            The rendered image.
        """
        typst_input = bytes(_TYPST_TEMPLATE.format(typst_code=typst_code), "utf-8")
        typst_image_bytes = self.compiler.compile(input=typst_input, format="png", ppi=self.ppi)
        typst_image_obj = image.open(BytesIO(typst_image_bytes)).convert(
            "L"
        )  # Grayscale for performance

        return typst_image_obj
