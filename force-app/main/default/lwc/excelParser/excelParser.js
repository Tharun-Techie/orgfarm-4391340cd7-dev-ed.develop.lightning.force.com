import { LightningElement, track } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import SHEETJS from '@salesforce/resourceUrl/sheetjs';

export default class ExcelParser extends LightningElement {
    @track data = [];
    @track columns = [];

    sheetJsLoaded = false;

    async connectedCallback() {
        if (!this.sheetJsLoaded) {
            await loadScript(this, SHEETJS);
            this.sheetJsLoaded = true;
        }
    }

    handleFileUpload(event) {
        const file = event.target.files[0];
        if (!file) return;

        const reader = new FileReader();

        reader.onload = (e) => {
            const binary = e.target.result;
            const workbook = XLSX.read(binary, { type: "binary" });

            const sheetName = "CAM Output Consol";
            const worksheet = workbook.Sheets[sheetName];
            if (!worksheet) {
                alert(`Sheet "${sheetName}" not found!`);
                return;
            }

            // Raw grid
            let grid = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

            // ❗ 1) Skip first 2 header rows
            const headerRow = grid[2]; // ROW 3 in Excel

            // ❗ 2) Skip the 3 rows (1,2,3) → starting data at row 4
            grid = grid.slice(3);

            // ❗ 3) Remove empty rows
            grid = grid.filter(r => r.some(c => c !== undefined && c !== null && c !== ""));

            // ❗ 4) Remove <extra_field_*>
            grid = grid.filter(row =>
                !row.some(cell =>
                    typeof cell === "string" &&
                    cell.trim().startsWith("<extra_field_")
                )
            );

            // ❗ 5) Fix empty headers
            const fixedHeader = headerRow.map((h, i) => {
                if (!h || h.toString().trim() === "") {
                    return "Column" + (i + 1);
                }
                return h.toString().trim();
            });

            // ❗ 6) Convert grid to JSON using fixed header
            const finalJson = grid.map(row => {
                const obj = {};
                fixedHeader.forEach((col, index) => (obj[col] = row[index]));
                return obj;
            });

            this.columns = fixedHeader;
            this.data = finalJson;

            console.log("FINAL JSON:", JSON.parse(finalJson));
        };

        reader.readAsBinaryString(file);
    }
}