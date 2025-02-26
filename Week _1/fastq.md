## **Understanding FASTQ Files**
A **FASTQ file** is a standard format used in bioinformatics to store raw sequence data from high-throughput sequencing platforms (e.g., Illumina, PacBio, Oxford Nanopore). Each read in a FASTQ file is represented using **four lines**:

### **1. Read Identifier (Header)**
The first line starts with an **"@"** symbol and contains the read identifier. This line includes metadata describing the sequencing process and experimental details.

Example:
```
@SEQ_ID
```
Typical information in a read identifier includes:
- Instrument name
- Run ID
- Flow cell ID
- Lane number
- Tile number
- X and Y coordinates on the flow cell
- Read number (forward or reverse)
- Whether the read is filtered or not
- Index sequences (if multiplexed)

Example of an Illumina read identifier:
```
@M00123:57:000000000-A3LJG:1:1101:1825:2186 1:N:0:ACGT
```
This can be broken down into:
- **M00123** → Machine ID
- **57** → Run number
- **000000000-A3LJG** → Flow cell barcode
- **1** → Lane number
- **1101** → Tile number
- **1825:2186** → X, Y coordinates
- **1** → Read number (1 = forward, 2 = reverse)
- **N** → Whether the read failed filtering (Y = failed, N = passed)
- **0** → Control bits
- **ACGT** → Index sequence used for demultiplexing

---

### **2. Read Sequence**
The second line contains the actual nucleotide sequence (A, T, G, C, or N if unknown).

Example:
```
AGTCCAGTTGGAATCTCGGTAGCTGACT
```

- Each character represents one nucleotide base.
- The sequence length must match the length of the quality score string (Line 4).
- "N" is used when the sequencer was uncertain about the base call.

---

### **3. Separator Line**
The third line begins with a **"+"** symbol and may optionally repeat the read identifier.

Example:
```
+
```
or
```
+SEQ_ID
```

This line acts as a separator between the sequence (Line 2) and the quality scores (Line 4). In modern FASTQ files, it often contains only the "+" symbol.

---

### **4. Quality Scores**
The fourth line contains **ASCII-encoded quality scores**, representing the accuracy of each base call in the sequence.

Example:
```
!!''*((((***+))%%%++)(%%%%).1***-+*''))**55CCF>>CC
```
Each character corresponds to a **Phred quality score**, which indicates the probability that the base call is incorrect.

- Phred score formula:  
  \[
  Q = -10 \times \log_{10}(P)
  \]
  where \( P \) is the probability of an incorrect base call.
- The ASCII characters are used to encode these scores.
- Example of mapping ASCII to Phred:
  - **"!"** → Phred 0
  - **"#"** → Phred 2
  - **"@"** → Phred 31
  - **"J"** → Phred 41 (High quality)
- **Higher Phred scores = More confidence in base call**

---

## **Why is Quality Control (QC) Important?**
### **1. Ensures Data Accuracy**
- Any errors in sequencing can **mislead downstream analyses**.
- False variants can be detected in genomic studies if low-quality reads are not filtered out.

### **2. Detects and Corrects Technical Biases**
- Errors from sequencing instruments (e.g., **base calling errors, GC biases**) can distort biological conclusions.
- Quality control (QC) **identifies these biases** and improves data reliability.

### **3. Optimizes Computational Resources**
- Low-quality reads increase computational costs.
- Removing them improves **efficiency in alignment, variant calling, and other analyses**.

### **4. Saves Costs on Re-sequencing**
- Identifying issues **early** prevents the need for expensive re-sequencing.

### **5. Meets Scientific Standards**
- Journals and databases **require** high-quality sequence data for publication and sharing.

---

## **FASTQC - A Tool for Quality Control**
**FastQC** is a widely used software for assessing sequencing quality in **FASTQ files**. It provides visual reports on key metrics, helping researchers **identify problems** before analysis.

### **Key Metrics in a FastQC Report**
1. **Basic Statistics**
2. **Per Base Sequence Quality**
3. **Per Sequence Quality Scores**
4. **Per Base Sequence Content**
5. **Sequence Duplication Levels**
6. **Per Base N Content**
7. **Adapter Content**
8. **Per Sequence GC Content**
9. **K-mer Content**
10. **Overrepresented Sequences**

---

### **1. Basic Statistics**
Provides an **overview of the sequencing dataset**, including:
- **Filename**: Name of the input file
- **File Type**: FASTQ, BAM, etc.
- **Encoding**: Phred score version (e.g., Phred+33, Phred+64)
- **Total Sequences**: Number of reads
- **Sequence Length**: Minimum, maximum, and average read length
- **%GC Content**: Percentage of **Guanine (G) + Cytosine (C)** bases

---

### **2. Per Base Sequence Quality**
- **Y-axis**: Phred Quality Score
- **X-axis**: Position along the read
- **Green (>28)** → High-quality
- **Yellow (20-28)** → Medium quality (Caution)
- **Red (<20)** → Low quality (Problematic)

> **Poor-quality regions** suggest sequencing errors or degradation.

---

### **3. Per Sequence Quality Scores**
- **Shows the distribution of quality scores across all reads**.
- A warning is issued if **most reads have an average quality below 27**.
- A failure occurs if **most reads have an average quality below 20**.

---

### **4. Per Base Sequence Content**
- Measures the **percentage of each nucleotide (A, T, G, C) per position**.
- Imbalances in early read positions can indicate **sequencing biases or contamination**.

---

### **5. Sequence Duplication Levels**
- Reveals whether **certain sequences are overrepresented**.
- **High duplication** may result from **PCR bias, sequencing artifacts, or contaminants**.

---

### **6. Per Base N Content**
- **N's** represent **ambiguous base calls**.
- If N content is **high**, this suggests **instrument failure or poor sequencing chemistry**.

---

### **7. Adapter Content**
- Checks for **adapter sequences** that were not removed properly.
- **Warning**: If adapter sequences appear in **>5% of reads**.
- **Failure**: If adapter sequences appear in **>10% of reads**.

---

### **8. Per Sequence GC Content**
- A normal distribution is expected for **random genomic DNA**.
- **Deviations** suggest **contamination or technical biases**.

---

### **9. K-mer Content**
- **K-mers** are short sequences of length "k" (e.g., 4-mers: "ATGC").
- **Uneven k-mer distribution** suggests **biases, contaminants, or sequencing artifacts**.

---

### **10. Overrepresented Sequences**
- **Short sequences appearing too frequently** indicate possible contamination.
- **Warning**: If a sequence represents **>0.1%** of total reads.
- **Failure**: If a sequence represents **>1%** of total reads.

---

## **Conclusion**
Quality control is **essential** in sequencing projects. **FastQC** helps researchers quickly **identify and address issues**, ensuring that only **high-quality, reliable data** is used for downstream analysis.