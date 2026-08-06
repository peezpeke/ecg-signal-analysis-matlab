import wfdb
from scipy.io import savemat
import os

# ==============================
# Record to read
# ==============================
record_name = "100"

# Database folder
database_path = r"D:\ECG_project\mit-bih-arrhythmia-database-1.0.0"

# Output folder
output_folder = r"D:\ECG_project\output"

# ==============================
# Read ECG signal
# ==============================
record = wfdb.rdrecord(os.path.join(database_path, record_name))

# Read annotations
annotation = wfdb.rdann(os.path.join(database_path, record_name), "atr")

# ==============================
# Save everything to MATLAB file
# ==============================
output_file = os.path.join(output_folder, record_name + ".mat")

savemat(output_file, {
    "signal": record.p_signal,
    "fs": record.fs,
    "lead_names": record.sig_name,
    "annotation_samples": annotation.sample,
    "annotation_symbols": annotation.symbol
})

print("------------------------------------")
print("Record saved successfully!")
print("Output File :", output_file)
print("Sampling Frequency :", record.fs)
print("Signal Shape :", record.p_signal.shape)
print("Number of Annotations :", len(annotation.sample))
print("------------------------------------")