# Guía de Verificación de Migración Trezoa

## Objetivo
Demostrar mediante pruebas reproducibles que el repositorio Trezoa NO contiene referencias a Solana/SOL/SPL en:
- (A) Código fuente y configuraciones
- (B) Artefactos génesis/ledger
- (C) Documentación y CI/CD

---

## Pre-requisitos

### Herramientas necesarias:
```bash
# Verificar que tienes las herramientas instaladas
which git
which grep
which find
which shasum
which strings

# Si falta 'strings', instalar binutils
brew install binutils  # macOS
```

### Preparación:
```bash
# 1. Estar en el directorio del repositorio
cd /Users/sterlingcore/trezoa

# 2. Asegurar que estás en el branch correcto
git status
git branch --show-current

# 3. Hacer permisos ejecutables a los scripts
chmod +x verify-trezoa-migration.sh
chmod +x verify-program-keys.sh
```

---

## SECCIÓN A: Verificación Completa del Repositorio

### Comando Principal:
```bash
./verify-trezoa-migration.sh
```

### Qué hace este script:
1. **Búsqueda de términos de Solana**: Busca case-sensitive e insensitive:
   - "Solana", "solana", "SOL", "sol", "SPL", "spl"
   - URLs: "solana.com", "solana-foundation", etc.
   - Proyectos relacionados: "Metaplex", "Anchor", "Agave", "Anza", "coral.xyz"

2. **Verificación de variables de entorno**: Busca `SOLANA_*` que no hayan sido convertidas a `TREZOA_*`

3. **Verificación de URLs y dominios**: Detecta enlaces a sitios de Solana

4. **Verificación de nombres de programas**: Confirma nomenclatura TPL (Trezoa Program Library)

5. **Búsqueda de llaves públicas conocidas de Solana**:
   - TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA (SPL Token)
   - TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb (Token-2022)
   - ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL (Associated Token)
   - MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr (Memo v1)
   - Memo1UhkJRfHyvLMcVucJwxXeuD728EqVDDwQDxFMNo (Memo v3)

### Evidencia producida:
- **Archivo de reporte**: `trezoa-verification-report-YYYYMMDD-HHMMSS.txt`
- **Contenido**:
  - Fecha y hora de ejecución
  - Commit hash verificado
  - Resultado de cada búsqueda (PASS/FAIL)
  - Listado de archivos y líneas con coincidencias (si existen)
  - Contador de pruebas pasadas/falladas

### Interpretación de resultados:

#### ✓ PASS (Éxito):
```
✓ PASS: Término 'Solana' no encontrado en código
  Detalles: 0 ocurrencias
```
**Significado**: El término NO se encontró (correcto, migración exitosa)

#### ✗ FAIL (Falla):
```
✗ FAIL: Término 'solana' encontrado en código
  Detalles: 5 ocurrencias encontradas
./some-file.rs:42: let solana_url = "https://api.solana.com"
```
**Significado**: El término SÍ se encontró (incorrecto, requiere corrección)

**Cómo corregir**: Edita el archivo indicado y reemplaza la referencia a Solana por Trezoa.

### Criterios de éxito:
- **PASS**: Total de pruebas FALLIDAS = 0
- **FAIL**: Total de pruebas FALLIDAS > 0

---

## SECCIÓN B: Verificación de Llaves de Programas

### Comando:
```bash
./verify-program-keys.sh
```

### Qué verifica:
1. **Verificación negativa**: Las llaves de Solana NO deben aparecer
2. **Verificación positiva**: Las llaves de Trezoa SÍ deben aparecer
3. **Archivos críticos**: Verifica archivos específicos que contienen llaves

### Llaves verificadas:

#### Solana (NO deben estar):
| Programa | Llave Pública |
|----------|---------------|
| SPL Token | TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA |
| SPL Token-2022 | TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb |
| Associated Token | ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL |
| Memo v1 | MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr |
| Memo v3 | Memo1UhkJRfHyvLMcVucJwxXeuD728EqVDDwQDxFMNo |

#### Trezoa (SÍ deben estar):
| Programa | Llave Pública |
|----------|---------------|
| TPL Token | F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4 |
| TPL Token-2022 | 8uWs1JBXDgzb1EbBKwyZ6JFuRpzdAqBTN1dZYfaJMEpu |
| TPL Associated Token | 43tZW5Ak5GjbHt3YBU2rUyaWpZJPLZcXFcJuP8GNfscv |
| TPL Memo v1 | EMrTTTcZSoFKfgqy4rTQPxRg24w7dVGfRNyMM7DRDxvM |
| TPL Memo v3 | 84XECa2ahfkNNYBj21kgvVs9BfqtvsFgUKSsbjpVEzGe |

### Evidencia producida:
- **Archivo**: `trezoa-keys-verification-YYYYMMDD-HHMMSS.txt`
- **Contenido**: Resultados de búsqueda de cada llave con ubicaciones

### Archivos críticos verificados:
- `accounts-db/src/inline_tpl_token.rs`
- `accounts-db/src/inline_tpl_token_2022.rs`
- `runtime/src/inline_tpl_associated_token_account.rs`
- `program-test/src/programs.rs`

---

## SECCIÓN C: Verificación de Artefactos Génesis

### Comandos para generar y verificar génesis:

#### 1. Verificar si existe génesis actual:
```bash
find . -name "genesis.bin" -o -name "genesis.tar.bz2" 2>/dev/null | grep -v target
```

#### 2. Si necesitas generar nuevo génesis:
```bash
# Compilar las herramientas de Trezoa
cargo build --release --bin trezoa-genesis

# Generar génesis de prueba
./target/release/trezoa-genesis \
  --bootstrap-validator identity.json vote-account.json stake-account.json \
  --ledger test-ledger \
  --faucet-pubkey <PUBKEY> \
  --faucet-lamports 500000000000000
```

#### 3. Verificar contenido del génesis:
```bash
# Calcular checksum
shasum -a 256 test-ledger/genesis.bin

# Buscar referencias a Solana en el binario
strings test-ledger/genesis.bin | grep -i "solana"

# Extraer información (si trezoa-ledger-tool está compilado)
./target/release/trezoa-ledger-tool genesis
```

### Interpretación:
- **PASS**: `strings` no devuelve referencias a "solana"
- **FAIL**: Se encuentran strings con "solana" en el génesis

### Cómo corregir si falla:
1. Verificar que usaste binarios compilados de Trezoa (no de Solana)
2. Regenerar el génesis con las herramientas correctas
3. Verificar que las llaves usadas sean de Trezoa

---

## SECCIÓN D: Verificación de Binarios Compilados

### 1. Compilar el proyecto:
```bash
# Compilación completa en modo release
cargo build --release

# O compilar componentes específicos
cargo build --release --bin trezoa-validator
cargo build --release --bin trezoa-genesis
```

### 2. Verificar binarios:
```bash
# Listar binarios compilados
ls -lh target/release/trezoa-*

# Buscar referencias a Solana en binarios
for binary in target/release/trezoa-*; do
  echo "Verificando: $binary"
  strings "$binary" | grep -i "solana" | grep -v "trezoa" || echo "  ✓ Sin referencias"
done
```

### 3. Verificación con grep en binarios:
```bash
# Usar ripgrep si está disponible (más rápido)
if command -v rg &> /dev/null; then
  rg --binary --text "solana" target/release/trezoa-validator || echo "✓ Sin referencias"
else
  strings target/release/trezoa-validator | grep -i "solana" || echo "✓ Sin referencias"
fi
```

### Interpretación:
- **PASS**: No se encuentran referencias a "solana" (o solo en contexto de "trezoa")
- **FAIL**: Se encuentran referencias directas a Solana

---

## SECCIÓN E: Verificación de Submódulos Git

### 1. Listar submódulos:
```bash
git submodule status
git config --file .gitmodules --get-regexp path
```

### 2. Verificar submódulos:
```bash
# Si hay submódulos, verificarlos también
git submodule foreach 'grep -rn "solana" . | grep -v Copyright || echo "✓ Limpio"'
```

---

## Ejecución Completa - Procedimiento Paso a Paso

### Script Maestro:
```bash
#!/bin/bash
# run-full-verification.sh - Ejecuta todas las verificaciones

echo "======================================"
echo "VERIFICACIÓN COMPLETA TREZOA"
echo "======================================"
echo ""

# 1. Información del repositorio
echo "1. Información del repositorio"
echo "------------------------------"
git status
echo ""
echo "Commit actual: $(git rev-parse HEAD)"
echo "Branch: $(git branch --show-current)"
echo ""

# 2. Verificación principal
echo "2. Ejecutando verificación de código..."
./verify-trezoa-migration.sh
RESULT1=$?
echo ""

# 3. Verificación de llaves
echo "3. Ejecutando verificación de llaves..."
./verify-program-keys.sh
RESULT2=$?
echo ""

# 4. Verificación de génesis (si existe)
echo "4. Verificando artefactos génesis..."
GENESIS_FILES=$(find . -name "genesis.bin" 2>/dev/null | grep -v target | head -1)
if [ -n "$GENESIS_FILES" ]; then
  echo "Génesis encontrado: $GENESIS_FILES"
  shasum -a 256 "$GENESIS_FILES"
  echo "Buscando referencias a Solana..."
  strings "$GENESIS_FILES" | grep -i "solana" || echo "✓ Sin referencias a Solana"
else
  echo "ℹ No hay archivos genesis.bin para verificar"
fi
echo ""

# 5. Verificación de binarios (si existen)
echo "5. Verificando binarios compilados..."
if [ -d "target/release" ]; then
  VALIDATORS=$(find target/release -name "trezoa-validator" -type f 2>/dev/null | head -1)
  if [ -n "$VALIDATORS" ]; then
    echo "Binario encontrado: $VALIDATORS"
    echo "Buscando referencias a Solana..."
    strings "$VALIDATORS" | grep -i "solana" | grep -v "trezoa" | head -5 || echo "✓ Sin referencias directas"
  else
    echo "ℹ Binarios no compilados (ejecuta: cargo build --release)"
  fi
else
  echo "ℹ Directorio target/release no existe"
fi
echo ""

# Resultado final
echo "======================================"
echo "RESULTADO FINAL"
echo "======================================"
if [ $RESULT1 -eq 0 ] && [ $RESULT2 -eq 0 ]; then
  echo "✓✓✓ TODAS LAS VERIFICACIONES PASARON ✓✓✓"
  echo ""
  echo "El repositorio Trezoa está correctamente migrado."
  echo "No se encontraron referencias a Solana."
  exit 0
else
  echo "✗✗✗ ALGUNAS VERIFICACIONES FALLARON ✗✗✗"
  echo ""
  echo "Revisa los reportes generados para detalles."
  exit 1
fi
```

### Guardar y ejecutar:
```bash
# Guardar el script
cat > run-full-verification.sh << 'EOF'
[contenido del script arriba]
EOF

# Dar permisos
chmod +x run-full-verification.sh

# Ejecutar
./run-full-verification.sh
```

---

## Comandos Individuales de Verificación

### Búsqueda manual de términos:
```bash
# Buscar "Solana" (case-sensitive)
grep -rn "Solana" . --exclude-dir=target --exclude-dir=.git | grep -v "Copyright"

# Buscar "solana" (case-insensitive)
grep -rin "solana" . --exclude-dir=target --exclude-dir=.git | grep -v "Copyright"

# Buscar variables SOLANA_*
grep -rn "SOLANA_" . --exclude-dir=target --exclude-dir=.git

# Buscar URLs
grep -rn "solana\.com\|solanalabs\.com" . --exclude-dir=target --exclude-dir=.git
```

### Verificación de llaves específicas:
```bash
# Buscar llave de SPL Token (Solana) - NO debe estar
grep -rn "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA" . --exclude-dir=target

# Buscar llave de TPL Token (Trezoa) - SÍ debe estar
grep -rn "F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4" . --exclude-dir=target
```

### Verificación de archivos críticos:
```bash
# Ver el contenido de archivos de llaves
cat accounts-db/src/inline_tpl_token.rs | grep "F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4"
cat accounts-db/src/inline_tpl_token_2022.rs | grep "8uWs1JBXDgzb1EbBKwyZ6JFuRpzdAqBTN1dZYfaJMEpu"
cat runtime/src/inline_tpl_associated_token_account.rs | grep "43tZW5Ak5GjbHt3YBU2rUyaWpZJPLZcXFcJuP8GNfscv"
```

---

## Interpretación de Resultados - Criterios PASS/FAIL

### ✓ PASS - Migración Exitosa:
- **0 referencias** a términos de Solana (excepto en copyright/licencia)
- **Todas las llaves** son de Trezoa
- **Variables de entorno** usan prefijo `TREZOA_*`
- **URLs** apuntan a dominios de Trezoa
- **Binarios** no contienen strings de Solana
- **Génesis** no contiene marcas de Solana

### ✗ FAIL - Requiere Corrección:
- **Se encuentran referencias** a Solana en código/configs
- **Llaves de Solana** presentes en el código
- **Variables `SOLANA_*`** sin convertir
- **URLs de Solana** en documentación o código
- **Binarios** contienen referencias a Solana

---

## Corrección de Problemas

### Si encuentras referencias a Solana:

#### 1. Identificar el archivo y línea:
```bash
grep -rn "término_encontrado" . --exclude-dir=target
```

#### 2. Editar el archivo:
```bash
# Usar tu editor preferido
vim path/to/file.rs
# o
code path/to/file.rs
```

#### 3. Reemplazar la referencia:
- Cambiar "Solana" por "Trezoa"
- Cambiar "solana" por "trezoa"
- Cambiar "SOLANA_*" por "TREZOA_*"
- Cambiar URLs de Solana por URLs de Trezoa

#### 4. Re-verificar:
```bash
./verify-trezoa-migration.sh
```

#### 5. Hacer commit:
```bash
git add .
git commit -m "Fix: Remove remaining Solana reference in [file]"
git push origin master
```

---

## Checklist Final

Antes de considerar la migración completa, verifica:

- [ ] `./verify-trezoa-migration.sh` pasa con 0 fallas
- [ ] `./verify-program-keys.sh` pasa con 0 fallas
- [ ] Génesis no contiene referencias a Solana (si aplica)
- [ ] Binarios compilados no contienen referencias (si aplica)
- [ ] Todos los cambios están en commit
- [ ] Repositorio está sincronizado con GitHub

---

## Contacto y Soporte

Si encuentras problemas o necesitas clarificación:
1. Revisa los reportes generados (`*.txt`)
2. Ejecuta los comandos individuales para más detalle
3. Verifica que estás usando las versiones correctas de las herramientas

---

## Apéndice: Referencia de Llaves

### Verificación de Llaves en Volumen Externo

Si necesitas verificar las llaves originales:
```bash
# Listar llaves en el volumen
ls -la /Volumes/TREZOA_KEYS/09-PROGRAM_KEYS/

# Ver la llave pública de un keypair
solana-keygen pubkey /Volumes/TREZOA_KEYS/09-PROGRAM_KEYS/tpl_token.json
```

### Comparación de Llaves:
```bash
# Extraer llave del código
LLAVE_CODIGO=$(grep -o 'F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4' accounts-db/src/inline_tpl_token.rs)

# Extraer llave del archivo
LLAVE_ARCHIVO=$(solana-keygen pubkey /Volumes/TREZOA_KEYS/09-PROGRAM_KEYS/tpl_token.json)

# Comparar
if [ "$LLAVE_CODIGO" == "$LLAVE_ARCHIVO" ]; then
  echo "✓ Las llaves coinciden"
else
  echo "✗ Las llaves NO coinciden"
fi
```

---

**Última actualización**: 20 de enero de 2026
**Versión del documento**: 1.0
**Autor**: Trezoa Team
