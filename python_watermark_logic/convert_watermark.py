import sys
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from PIL import Image

def reduce_opacity(im, opacity):
    """Returns an image with reduced opacity."""
    assert opacity >= 0 and opacity <= 1
    if im.mode != 'RGBA':
        im = im.convert('RGBA')
    else:
        im = im.copy()
    alpha = im.split()[3]
    alpha = alpha.point(lambda p: p * opacity)
    im.putalpha(alpha)
    return im

def convert_image_to_pdf(image_path, pdf_path):
    # Open the image to get its original dimensions
    try:
        img = Image.open(image_path)
        img = reduce_opacity(img, 0.25) # 25% opacity
        temp_img_path = "temp_transparent_watermark.png"
        img.save(temp_img_path, "PNG")
        
        img_width, img_height = img.size
    except Exception as e:
        print(f"Failed to open image: {e}")
        return
        
    c = canvas.Canvas(pdf_path, pagesize=A4)
    a4_width, a4_height = A4
    
    # Calculate dimensions to fit within A4 while preserving aspect ratio
    # Let's say we want it to take up at most 80% of the page width or height
    max_width = a4_width * 0.8
    max_height = a4_height * 0.8
    
    ratio = min(max_width / img_width, max_height / img_height)
    new_width = img_width * ratio
    new_height = img_height * ratio
    
    # Calculate position to center the image
    x = (a4_width - new_width) / 2
    y = (a4_height - new_height) / 2
    
    # Draw the image
    c.drawImage(temp_img_path, x, y, width=new_width, height=new_height, mask='auto')
    c.save()
    print(f"Successfully converted {image_path} to {pdf_path}")

if __name__ == "__main__":
    image_file = sys.argv[1]
    pdf_file = sys.argv[2]
    convert_image_to_pdf(image_file, pdf_file)
