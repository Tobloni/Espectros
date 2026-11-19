from pathlib import Path
import pandas as pd


def inspeccionar_excels(carpeta: Path) -> None:
    # Lista los archivos Excel en 'carpeta' e imprime sus hojas y primeras filas
    if not carpeta.is_dir():
        print(f"La ruta no existe o no es una carpeta: {carpeta}")
        return

    # Busca .xlsx y .xls, ignorando archivos temporales (~$) y duplicados
    extensiones = {".xlsx", ".xls"}
    archivos_excel = sorted(
        f for f in carpeta.iterdir()
        if f.is_file() and f.suffix.lower() in extensiones and not f.name.startswith("~$")
    )

    if not archivos_excel:
        print(f"No se encontraron archivos Excel en: {carpeta}")
        return

    print("Archivos encontrados:", [f.name for f in archivos_excel])

    for ruta in archivos_excel:
        try:
            with pd.ExcelFile(ruta) as xls:
                print(f"\n=== {ruta.name} === Hojas: {xls.sheet_names}")
                for hoja in xls.sheet_names:
                    df = xls.parse(hoja)
                    print(f"  Hoja: {hoja} | shape: {df.shape}")
                    print(df.head(5))
        except Exception as e:
            print(f"\n[Error] No se pudo leer '{ruta.name}': {e}")


if __name__ == "__main__":
    ruta_carpeta = Path(".")
    inspeccionar_excels(ruta_carpeta)
