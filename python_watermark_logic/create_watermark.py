from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.lib.units import inch

def create_watermark(filename):
    # A4 size is (595.27, 841.89) points
    c = canvas.Canvas(filename, pagesize=A4)
    # Move the origin up and to the left
    c.translate(inch, inch)
    
    # Set the font and size
    c.setFont("Helvetica", 60)
    
    # Set the color and alpha for transparency
    # Gray color, 30% alpha
    c.setFillColorRGB(0.5, 0.5, 0.5, alpha=0.3)
    
    # Rotate the canvas and draw the string
    c.rotate(45)
    c.drawString(4 * inch, 0, "CONFIDENTIAL")
    
    c.save()

if __name__ == "__main__":
    create_watermark("watermark.pdf")
