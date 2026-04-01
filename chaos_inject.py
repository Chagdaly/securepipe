import subprocess
import shutil
import os

SCANNER_DIR = "phase3-scanner"
MAIN_TF = os.path.join(SCANNER_DIR, "main.tf")
BACKUP_TF = os.path.join(SCANNER_DIR, "main.tf.backup")

VULN_BLOCK = '''
# CHAOS INJECT: Hardcoded credentials (simulated secret leak)
# aws_access_key = "AKIAIOSFODNN7EXAMPLE"
# aws_secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# CHAOS INJECT: Root account usage allowed
resource "aws_iam_role" "chaos_role" {
  name = "securepipe-chaos-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { AWS = "*" }
    }]
  })
}

# CHAOS INJECT: S3 bucket with no restrictions
resource "aws_s3_bucket" "chaos" {
  bucket = "securepipe-chaos-310544499318"
}

resource "aws_s3_bucket_public_access_block" "chaos" {
  bucket                  = aws_s3_bucket.chaos.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
'''

def inject():
    print("[*] Backing up original main.tf...")
    shutil.copy(MAIN_TF, BACKUP_TF)
    
    print("[*] Injecting vulnerabilities into main.tf...")
    with open(MAIN_TF, "a") as f:
        f.write(VULN_BLOCK)
    
    print("[*] Staging changes...")
    subprocess.run(["git", "add", "."], check=True)
    
    print("[*] Committing chaos injection...")
    subprocess.run(["git", "commit", "-m", 
        "chaos: inject vulnerable resources for pipeline demo"], check=True)
    
    print("[*] Pushing to GitHub to trigger pipeline...")
    subprocess.run(["git", "push", "origin", "main"], check=True)
    
    print("[+] Chaos injected! Check GitHub Actions tab to watch pipeline catch it.")
    print("[+] Go to: https://github.com/Chagdaly/securepipe/actions")

def restore():
    print("[*] Restoring original main.tf...")
    shutil.copy(BACKUP_TF, MAIN_TF)
    os.remove(BACKUP_TF)
    
    subprocess.run(["git", "add", "."], check=True)
    subprocess.run(["git", "commit", "-m", 
        "chaos: restore clean infrastructure after demo"], check=True)
    subprocess.run(["git", "push", "origin", "main"], check=True)
    
    print("[+] Restored! Infrastructure is clean again.")

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Usage: python chaos_inject.py inject")
        print("       python chaos_inject.py restore")
    elif sys.argv[1] == "inject":
        inject()
    elif sys.argv[1] == "restore":
        restore()
    else:
        print("Unknown command. Use 'inject' or 'restore'")