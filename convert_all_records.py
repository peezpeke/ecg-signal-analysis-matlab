import os
import wfdb
from scipy.io import savemat

# MIT-BIH source folder
input_folder = r"D:\ECG_project\mit-bih-arrhythmia-database-1.0.0"

# MATLAB output folder
output_folder = r"D:\ECG_project\output"

os.makedirs(output_folder, exist_ok=True)

# Find all ECG records from .hea files
record_files = [
    file.replace(".hea", "")
    for file in os.listdir(input_folder)
    if file.endswith(".hea")
]

record_files.sort()

print("Records found:", len(record_files))
print(record_files)

for record_id in record_files:

    print("\n--------------------------------")
    print("Processing Record:", record_id)
    print("--------------------------------")

    record_path = os.path.join(
        input_folder,
        record_id
    )

    try:

        # Read ECG signal
        record = wfdb.rdrecord(record_path)

        # Read expert annotations
        annotation = wfdb.rdann(
            record_path,
            "atr"
        )

        # ECG signal
        signal = record.p_signal

        # Sampling frequency
        fs = record.fs

        # Annotation locations
        annotation_samples = annotation.sample

        # Annotation symbols
        annotation_symbols = annotation.symbol

        # Lead names
        lead_names = record.sig_name

        # Output file
        output_file = os.path.join(
            output_folder,
            record_id + ".mat"
        )

        # Save MATLAB file
        savemat(
            output_file,
            {
                "signal": signal,
                "fs": fs,
                "annotation_samples": annotation_samples,
                "annotation_symbols": annotation_symbols,
                "lead_names": lead_names
            }
        )

        print("Saved:", output_file)

    except Exception as e:

        print("ERROR processing", record_id)
        print(e)


print("\n================================")
print("Conversion Completed")
print("================================")