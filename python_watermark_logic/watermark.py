import os
import glob
import logging
from datetime import datetime
from pypdf import PdfReader, PdfWriter
from tqdm import tqdm
import sys

# Configure basic logging for debugging and error tracking
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

def process_pdfs(source_dir, watermark_path):
    """
    Iterates through a source directory of PDFs, applies a watermark to each page,
    and saves them in a timestamped results directory.
    """
    if not os.path.exists(source_dir):
        logging.error(f"Source directory not found: {source_dir}")
        return
    
    if not os.path.exists(watermark_path):
        logging.error(f"Watermark file not found: {watermark_path}")
        return

    # Find all PDFs in the source directory
    pdf_files = glob.glob(os.path.join(source_dir, '*.pdf'))
    # Filter out the watermark file itself if it's in the same directory
    pdf_files = [f for f in pdf_files if os.path.abspath(f) != os.path.abspath(watermark_path)]

    if not pdf_files:
        logging.warning(f"No PDF files found in {source_dir}")
        return

    # Create timestamped output directory
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_dir = os.path.join(os.path.dirname(source_dir), f"Watermarked_Results_{timestamp}")
    os.makedirs(output_dir, exist_ok=True)
    logging.info(f"Saving watermarked files to: {output_dir}")

    # Load the watermark PDF
    try:
        watermark_reader = PdfReader(watermark_path)
        watermark_page = watermark_reader.pages[0]
    except Exception as e:
        logging.error(f"Failed to load watermark PDF: {e}")
        return

    success_count = 0
    fail_count = 0

    # Process each PDF with a progress bar
    for pdf_file in tqdm(pdf_files, desc="Watermarking PDFs", unit="file"):
        try:
            reader = PdfReader(pdf_file)
            writer = PdfWriter()

            # Check for encryption
            if reader.is_encrypted:
                if not reader.decrypt(""):
                    logging.warning(f"Skipping encrypted file (requires password): {os.path.basename(pdf_file)}")
                    fail_count += 1
                    continue

            for page in reader.pages:
                # Merge the watermark over the page
                page.merge_page(watermark_page, over=True)
                writer.add_page(page)

            # Save the new PDF
            output_filename = os.path.basename(pdf_file)
            output_filepath = os.path.join(output_dir, output_filename)
            with open(output_filepath, "wb") as output_stream:
                writer.write(output_stream)
            
            success_count += 1

        except Exception as e:
            logging.error(f"Error processing {os.path.basename(pdf_file)}: {e}")
            fail_count += 1

    # Print summary
    print("\n--- Execution Summary ---")
    print(f"Total files found: {len(pdf_files)}")
    print(f"Successfully processed: {success_count}")
    print(f"Failed/Skipped: {fail_count}")
    print(f"Results saved in: {output_dir}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python watermark.py <path_to_source_dir> <path_to_watermark_pdf>")
        sys.exit(1)

    source_directory = sys.argv[1]
    watermark_file = sys.argv[2]
    
    process_pdfs(source_directory, watermark_file)
