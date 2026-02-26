import requests
import os

missing_files = [
    ("1j1VQY7C8wSK5US_IfYCZm1YGp6YVlmZj", "Mrs. VANDANA KUMARI.pdf"),
    ("1NNAAM3HB17DNnoPdPotftaBPPmYYaAJ1", "Mrs. VIJAY CHAUHAN.pdf"),
    ("1e-1ge_e1Cqf7PcKnme2qYlJJzuBN819h", "Ms. DEEPA KUMARI.pdf"),
    ("15ObeV7pVcKgwvwcl5IQ6OUbVTo0M_WNT", "Ms. MADHVI.pdf"),
    ("1iq5nO2kOFQzDydHtAms1AvJQBCOMjYtX", "Ms. MANSI nimbus.pdf"),
    ("1sbxMV0eZ3yQFZpB9MXDUokPy9vBAIFXr", "Ms. NANDHINI.pdf"),
    ("1_-QOhQRXvL4kOBLiVAfaJfyY48Eo39xH", "Ms. NITIKA THAKUR.pdf"),
    ("1_KVBrn1KWG7R2uUOT094I2_xptJSzKuR", "Ms. SANDIPIKA nimbus.pdf"),
    ("1D9U4djTQnnPtUReW1996AeNwdOulhn5i", "Ms. SHASHI PUNDIR nimbus.pdf"),
    ("1SJRfTIKWtd4xIhp67C6zou_tHfC0tmcO", "Ms. VINITA nimbus.pdf"),
    ("1WAccBd9-5VA7DYGh5RxVBXQkqRdJjdKv", "Nimbus Hospital.pdf"),
    ("1r-M5dFbkOWa7aSy5gCOlxZEBiGlzIhoT", "NISHA nimbus.pdf"),
    ("1sCuVmIFChWcoglHgifvkypcFxnHYGJFN", "RITIKA nimbus.pdf"),
    # It says 14 files failed but here are 13. I'll add the one more if there was a 14th, but checking my previous output, it only listed 13 failed files...
]

output_dir = "/Users/gurman/Coding Projects/PDF_Watermarker/source_pdfs/Nimbus Report"

def download_file(file_id, file_name):
    url = f"https://drive.google.com/uc?export=download&id={file_id}"
    response = requests.get(url, stream=True)
    
    if response.status_code == 200:
        file_path = os.path.join(output_dir, file_name)
        with open(file_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)
        print(f"Downloaded: {file_name}")
    else:
        print(f"Failed to download {file_name} - HTTP {response.status_code}")

if __name__ == "__main__":
    for file_id, file_name in missing_files:
        download_file(file_id, file_name)
