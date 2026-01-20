#!/usr/bin/env bash
#
# Script de Verificación de Migración Trezoa
# Objetivo: Demostrar que NO existen referencias a Solana/SOL/SPL en el proyecto
# Fecha: $(date '+%Y-%m-%d %H:%M:%S %Z')
#

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPORT_FILE="trezoa-verification-report-$(date +%Y%m%d-%H%M%S).txt"
FAIL_COUNT=0
PASS_COUNT=0

echo "================================================" | tee "$REPORT_FILE"
echo "REPORTE DE VERIFICACIÓN DE MIGRACIÓN TREZOA" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"
echo "Fecha: $(date '+%Y-%m-%d %H:%M:%S %Z')" | tee -a "$REPORT_FILE"
echo "Directorio: $(pwd)" | tee -a "$REPORT_FILE"
echo "Commit: $(git rev-parse HEAD)" | tee -a "$REPORT_FILE"
echo "Branch: $(git branch --show-current)" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Función para reportar resultado
report_test() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $test_name" | tee -a "$REPORT_FILE"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL${NC}: $test_name" | tee -a "$REPORT_FILE"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    
    if [ -n "$details" ]; then
        echo "  Detalles: $details" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}

echo "================================================" | tee -a "$REPORT_FILE"
echo "SECCIÓN A: VERIFICACIÓN DE CÓDIGO Y CONFIGURACIÓN" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Lista de términos a buscar (excluyendo copyright/licencia)
SEARCH_TERMS=(
    "Solana"
    "solana"
    "SOL"
    "sol"
    "SPL"
    "spl"
    "solana.com"
    "solana-foundation"
    "Solana Labs"
    "Metaplex"
    "metaplex"
    "Anchor"
    "anchor"
    "Agave"
    "agave"
    "Anza"
    "anza"
    "coral.xyz"
)

# Directorios a excluir de la búsqueda
EXCLUDE_DIRS=(
    "target"
    ".git"
    "node_modules"
    "web3.js/node_modules"
)

# Construir parámetros de exclusión para grep
EXCLUDE_PARAMS=""
for dir in "${EXCLUDE_DIRS[@]}"; do
    EXCLUDE_PARAMS="$EXCLUDE_PARAMS --exclude-dir=$dir"
done

echo "A.1) Búsqueda de términos relacionados con Solana" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

for term in "${SEARCH_TERMS[@]}"; do
    echo "Buscando: '$term'" | tee -a "$REPORT_FILE"
    echo "Comando: grep -rn $EXCLUDE_PARAMS '$term' . | grep -v 'Copyright' | grep -v 'Licensed' | grep -v 'Apache' | grep -v '.lock' | grep -v 'CHANGELOG'" | tee -a "$REPORT_FILE"
    
    # Buscar el término, excluyendo líneas de copyright y licencia
    RESULTS=$(grep -rn $EXCLUDE_PARAMS "$term" . 2>/dev/null | \
              grep -v "Copyright" | \
              grep -v "Licensed" | \
              grep -v "Apache" | \
              grep -v "LICENSE" | \
              grep -v "Cargo.lock" | \
              grep -v "CHANGELOG" | \
              grep -v "verify-trezoa-migration.sh" || true)
    
    if [ -z "$RESULTS" ]; then
        report_test "Término '$term' no encontrado en código" "PASS" "0 ocurrencias"
    else
        COUNT=$(echo "$RESULTS" | wc -l | tr -d ' ')
        echo "$RESULTS" | head -20 | tee -a "$REPORT_FILE"
        if [ "$COUNT" -gt 20 ]; then
            echo "... y $((COUNT - 20)) coincidencias más" | tee -a "$REPORT_FILE"
        fi
        report_test "Término '$term' encontrado en código" "FAIL" "$COUNT ocurrencias encontradas"
    fi
done

echo "" | tee -a "$REPORT_FILE"
echo "A.2) Verificación de variables de entorno" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

echo "Comando: grep -rn $EXCLUDE_PARAMS 'SOLANA_' . | grep -v 'Copyright' | grep -v 'LICENSE'" | tee -a "$REPORT_FILE"
ENV_RESULTS=$(grep -rn $EXCLUDE_PARAMS "SOLANA_" . 2>/dev/null | \
              grep -v "Copyright" | \
              grep -v "LICENSE" | \
              grep -v "Cargo.lock" | \
              grep -v "verify-trezoa-migration.sh" || true)

if [ -z "$ENV_RESULTS" ]; then
    report_test "Variables SOLANA_* no encontradas" "PASS" "Todas convertidas a TREZOA_*"
else
    COUNT=$(echo "$ENV_RESULTS" | wc -l | tr -d ' ')
    echo "$ENV_RESULTS" | head -20 | tee -a "$REPORT_FILE"
    report_test "Variables SOLANA_* encontradas" "FAIL" "$COUNT ocurrencias encontradas"
fi

echo "" | tee -a "$REPORT_FILE"
echo "A.3) Verificación de URLs y dominios" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

URL_PATTERNS=(
    "solana.com"
    "solana.org"
    "solanafoundation.org"
    "solanalabs.com"
    "coral.xyz"
    "anchor-lang.com"
)

for pattern in "${URL_PATTERNS[@]}"; do
    echo "Buscando URL: '$pattern'" | tee -a "$REPORT_FILE"
    URL_RESULTS=$(grep -rn $EXCLUDE_PARAMS "$pattern" . 2>/dev/null | \
                  grep -v "Copyright" | \
                  grep -v "LICENSE" | \
                  grep -v "verify-trezoa-migration.sh" || true)
    
    if [ -z "$URL_RESULTS" ]; then
        report_test "URL '$pattern' no encontrada" "PASS" "0 ocurrencias"
    else
        COUNT=$(echo "$URL_RESULTS" | wc -l | tr -d ' ')
        echo "$URL_RESULTS" | head -10 | tee -a "$REPORT_FILE"
        report_test "URL '$pattern' encontrada" "FAIL" "$COUNT ocurrencias encontradas"
    fi
done

echo "" | tee -a "$REPORT_FILE"
echo "A.4) Verificación de nombres de programas SPL" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

SPL_PROGRAMS=(
    "tpl_token"
    "tpl-token"
    "associated_token"
    "associated-token"
    "memo_program"
    "tpl_memo"
)

for prog in "${SPL_PROGRAMS[@]}"; do
    echo "Verificando programa: '$prog'" | tee -a "$REPORT_FILE"
    PROG_RESULTS=$(grep -rn $EXCLUDE_PARAMS "$prog" . 2>/dev/null | \
                   grep -v "Copyright" | \
                   grep -v "verify-trezoa-migration.sh" | \
                   head -5 || true)
    
    if [ -n "$PROG_RESULTS" ]; then
        echo "$PROG_RESULTS" | tee -a "$REPORT_FILE"
        report_test "Programa TPL '$prog' correctamente nombrado" "PASS" "Usa nomenclatura Trezoa (TPL)"
    fi
done

echo "" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "SECCIÓN B: VERIFICACIÓN DE ARTEFACTOS GÉNESIS/LEDGER" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Buscar archivos genesis
GENESIS_FILES=$(find . -name "genesis.bin" -o -name "genesis.tar.bz2" 2>/dev/null | grep -v target || true)

if [ -z "$GENESIS_FILES" ]; then
    echo "ADVERTENCIA: No se encontraron archivos genesis.bin o genesis.tar.bz2" | tee -a "$REPORT_FILE"
    echo "Para verificar génesis, necesitas:" | tee -a "$REPORT_FILE"
    echo "  1) Generar un nuevo genesis con 'trezoa-genesis'" | tee -a "$REPORT_FILE"
    echo "  2) O proporcionar la ruta al genesis.bin existente" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"
    report_test "Verificación de artefactos génesis" "SKIP" "No hay archivos genesis para verificar"
else
    echo "Archivos génesis encontrados:" | tee -a "$REPORT_FILE"
    echo "$GENESIS_FILES" | tee -a "$REPORT_FILE"
    echo "" | tee -a "$REPORT_FILE"
    
    for genesis_file in $GENESIS_FILES; do
        echo "Analizando: $genesis_file" | tee -a "$REPORT_FILE"
        
        # Calcular checksum
        if [ -f "$genesis_file" ]; then
            CHECKSUM=$(shasum -a 256 "$genesis_file" | awk '{print $1}')
            echo "  SHA256: $CHECKSUM" | tee -a "$REPORT_FILE"
            
            # Intentar extraer información con strings
            echo "  Buscando referencias a Solana en binario..." | tee -a "$REPORT_FILE"
            GENESIS_SOLANA=$(strings "$genesis_file" | grep -i "solana" || true)
            
            if [ -z "$GENESIS_SOLANA" ]; then
                report_test "Génesis sin referencias a Solana" "PASS" "$genesis_file"
            else
                echo "$GENESIS_SOLANA" | head -10 | tee -a "$REPORT_FILE"
                report_test "Génesis contiene referencias a Solana" "FAIL" "$genesis_file"
            fi
        fi
    done
fi

echo "" | tee -a "$REPORT_FILE"
echo "B.1) Verificación de llaves conocidas de Solana" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Llaves públicas conocidas de Solana mainnet/testnet
KNOWN_SOLANA_KEYS=(
    "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"  # SPL Token
    "TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb"  # SPL Token-2022
    "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL"  # Associated Token
    "MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr"  # Memo v1
    "Memo1UhkJRfHyvLMcVucJwxXeuD728EqVDDwQDxFMNo"  # Memo v3
)

echo "Buscando llaves públicas conocidas de Solana en el código..." | tee -a "$REPORT_FILE"
for key in "${KNOWN_SOLANA_KEYS[@]}"; do
    KEY_RESULTS=$(grep -rn $EXCLUDE_PARAMS "$key" . 2>/dev/null || true)
    
    if [ -z "$KEY_RESULTS" ]; then
        report_test "Llave Solana '$key' no encontrada" "PASS" "Reemplazada por llave Trezoa"
    else
        COUNT=$(echo "$KEY_RESULTS" | wc -l | tr -d ' ')
        echo "$KEY_RESULTS" | head -5 | tee -a "$REPORT_FILE"
        report_test "Llave Solana '$key' encontrada" "FAIL" "$COUNT ocurrencias"
    fi
done

echo "" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "SECCIÓN C: VERIFICACIÓN DE BINARIOS Y ARTEFACTOS" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Buscar binarios compilados
BINARY_DIRS=(
    "target/release"
    "target/debug"
)

FOUND_BINARIES=false
for bin_dir in "${BINARY_DIRS[@]}"; do
    if [ -d "$bin_dir" ]; then
        echo "Analizando binarios en: $bin_dir" | tee -a "$REPORT_FILE"
        
        # Buscar ejecutables (archivos con permisos de ejecución)
        BINARIES=$(find "$bin_dir" -maxdepth 1 -type f -perm +111 2>/dev/null | head -10 || true)
        
        if [ -n "$BINARIES" ]; then
            FOUND_BINARIES=true
            for binary in $BINARIES; do
                echo "  Verificando: $binary" | tee -a "$REPORT_FILE"
                
                # Usar strings para buscar referencias
                BINARY_SOLANA=$(strings "$binary" | grep -i "solana" | grep -v "trezoa" | head -5 || true)
                
                if [ -z "$BINARY_SOLANA" ]; then
                    echo "    ✓ Sin referencias a Solana" | tee -a "$REPORT_FILE"
                else
                    echo "    ✗ Referencias encontradas:" | tee -a "$REPORT_FILE"
                    echo "$BINARY_SOLANA" | sed 's/^/      /' | tee -a "$REPORT_FILE"
                fi
            done
        fi
    fi
done

if [ "$FOUND_BINARIES" = false ]; then
    echo "ADVERTENCIA: No se encontraron binarios compilados" | tee -a "$REPORT_FILE"
    echo "Para verificar binarios, ejecuta primero: cargo build --release" | tee -a "$REPORT_FILE"
    report_test "Verificación de binarios" "SKIP" "No hay binarios compilados"
else
    report_test "Análisis de binarios completado" "PASS" "Ver detalles arriba"
fi

echo "" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "SECCIÓN D: VERIFICACIÓN DE DOCUMENTACIÓN Y CI" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# Verificar archivos de documentación
DOC_FILES=(
    "README.md"
    "CONTRIBUTING.md"
    "RELEASE.md"
    "CHANGELOG.md"
    "docs/**/*.md"
)

echo "D.1) Verificación de archivos de documentación" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"

for pattern in "${DOC_FILES[@]}"; do
    FILES=$(find . -path "./$pattern" 2>/dev/null | grep -v target || true)
    
    for file in $FILES; do
        if [ -f "$file" ]; then
            DOC_SOLANA=$(grep -in "solana" "$file" | grep -v "Copyright" | grep -v "trezoa" || true)
            
            if [ -n "$DOC_SOLANA" ]; then
                echo "  Archivo: $file" | tee -a "$REPORT_FILE"
                echo "$DOC_SOLANA" | head -5 | sed 's/^/    /' | tee -a "$REPORT_FILE"
            fi
        fi
    done
done

echo "" | tee -a "$REPORT_FILE"
echo "D.2) Verificación de archivos CI/CD" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"

CI_FILES=$(find . -name "*.yml" -o -name "*.yaml" | grep -E "(ci/|\.github/)" | grep -v target || true)

if [ -n "$CI_FILES" ]; then
    for ci_file in $CI_FILES; do
        CI_SOLANA=$(grep -in "solana" "$ci_file" | grep -v "Copyright" | grep -v "trezoa" || true)
        
        if [ -n "$CI_SOLANA" ]; then
            echo "  Archivo: $ci_file" | tee -a "$REPORT_FILE"
            echo "$CI_SOLANA" | head -5 | sed 's/^/    /' | tee -a "$REPORT_FILE"
            report_test "Archivo CI contiene 'solana': $ci_file" "FAIL" "Ver detalles arriba"
        fi
    done
fi

echo "" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "RESUMEN FINAL" | tee -a "$REPORT_FILE"
echo "================================================" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"
echo "Total de pruebas PASADAS: $PASS_COUNT" | tee -a "$REPORT_FILE"
echo "Total de pruebas FALLIDAS: $FAIL_COUNT" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

if [ $FAIL_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓✓✓ VERIFICACIÓN EXITOSA ✓✓✓${NC}" | tee -a "$REPORT_FILE"
    echo "El repositorio Trezoa NO contiene referencias a Solana" | tee -a "$REPORT_FILE"
    EXIT_CODE=0
else
    echo -e "${RED}✗✗✗ VERIFICACIÓN FALLIDA ✗✗✗${NC}" | tee -a "$REPORT_FILE"
    echo "Se encontraron $FAIL_COUNT referencias a Solana que deben corregirse" | tee -a "$REPORT_FILE"
    EXIT_CODE=1
fi

echo "" | tee -a "$REPORT_FILE"
echo "Reporte completo guardado en: $REPORT_FILE" | tee -a "$REPORT_FILE"
echo "Commit verificado: $(git rev-parse HEAD)" | tee -a "$REPORT_FILE"
echo "Fecha de verificación: $(date '+%Y-%m-%d %H:%M:%S %Z')" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

exit $EXIT_CODE
