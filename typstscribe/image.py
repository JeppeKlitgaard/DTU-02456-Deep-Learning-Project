from PIL import Image as image


def convert_to_rgb_white_bg(img: image.Image) -> image.Image:
    """
    Convert image to RGB with white background, taking care of oddities
    with certain image modes.

    Args:
        img (image.Image): Input image.

    Returns:
        image.Image: Converted image.
    """
    # Possible modes: https://pillow.readthedocs.io/en/stable/handbook/concepts.html
    if img.mode == "RGB":
        return img

    # PIL has dodgy handling of 16-bit images, see: https://github.com/python-pillow/Pillow/issues/5991
    if img.mode == "I;16":
        img = img.point(lambda i: i * (1 / 255)).convert("RGB")
        return img

    if (
        img.mode in ("RGBA", "LA")
        or (img.mode == "P" and "transparency" in img.info)
        or (img.mode == "L" and "transparency" in img.info)
    ):
        # Convert to RGBA to standardise the alpha channel handling
        alpha_img = img.convert("RGBA")
        bg = image.new("RGB", img.size, (255, 255, 255))
        bg.paste(alpha_img, mask=alpha_img)
        return bg

    else:
        # Raise error to ensure we have manually checked that this conversion is good
        # We got burned by assuming sensible conversions with I;16 before.
        raise NotImplementedError(f"Image mode '{img.mode}' not supported yet.")
