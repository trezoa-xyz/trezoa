#!/bin/bash

echo "Verificando llaves de Solana (NO deben estar)..."
echo "================================================"

echo ""
echo "1. SPL Token: TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"
grep -rn "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA" . --exclude-dir=target --exclude-dir=.git 2>/dev/null || echo "  ✓ NO encontrada"

echo ""
echo "2. SPL Token-2022: TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb"
grep -rn "TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb" . --exclude-dir=target --exclude-dir=.git 2>/dev/null || echo "  ✓ NO encontrada"

echo ""
echo "3. Associated Token: ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL"
grep -rn "ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL" . --exclude-dir=target --exclude-dir=.git 2>/dev/null || echo "  ✓ NO encontrada"

echo ""
echo "4. Memo v1: MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr"
grep -rn "MemoSq4gqABAXKb96qnH8TysNcWxMyWCqXgDLGmfcHr" . --exclude-dir=target --exclude-dir=.git 2>/dev/null || echo "  ✓ NO encontrada"

echo ""
echo "5. Memo v3: Memo1UhkJRfHyvLMcVucJwxXeuD728EqVDDwQDxFMNo"
grep -rn "Memo1UhkJRfHyvLMcVucJwxXeuD728EqVDDwQDxFMNo" . --exclude-dir=target --exclude-dir=.git 2>/dev/null || echo "  ✓ NO encontrada"

echo ""
echo ""
echo "Verificando llaves de Trezoa (SÍ deben estar)..."
echo "================================================"

echo ""
echo "1. TPL Token: F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4"
COUNT=$(grep -rn "F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
    echo "  ✓ Encontrada en $COUNT ubicaciones"
    grep -rn "F68d7D1DMSfnS2kfdMWJKFbzHvcQr39t7fMsGLW4hsS4" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | head -2
else
    echo "  ✗ NO encontrada"
fi

echo ""
echo "2. TPL Token-2022: 8uWs1JBXDgzb1EbBKwyZ6JFuRpzdAqBTN1dZYfaJMEpu"
COUNT=$(grep -rn "8uWs1JBXDgzb1EbBKwyZ6JFuRpzdAqBTN1dZYfaJMEpu" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
    echo "  ✓ Encontrada en $COUNT ubicaciones"
    grep -rn "8uWs1JBXDgzb1EbBKwyZ6JFuRpzdAqBTN1dZYfaJMEpu" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | head -2
else
    echo "  ✗ NO encontrada"
fi

echo ""
echo "3. TPL Associated Token: 43tZW5Ak5GjbHt3YBU2rUyaWpZJPLZcXFcJuP8GNfscv"
COUNT=$(grep -rn "43tZW5Ak5GjbHt3YBU2rUyaWpZJPLZcXFcJuP8GNfscv" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
    echo "  ✓ Encontrada en $COUNT ubicaciones"
    grep -rn "43tZW5Ak5GjbHt3YBU2rUyaWpZJPLZcXFcJuP8GNfscv" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | head -2
else
    echo "  ✗ NO encontrada"
fi

echo ""
echo "4. TPL Memo v1: EMrTTTcZSoFKfgqy4rTQPxRg24w7dVGfRNyMM7DRDxvM"
COUNT=$(grep -rn "EMrTTTcZSoFKfgqy4rTQPxRg24w7dVGfRNyMM7DRDxvM" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
    echo "  ✓ Encontrada en $COUNT ubicaciones"
    grep -rn "EMrTTTcZSoFKfgqy4rTQPxRg24w7dVGfRNyMM7DRDxvM" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | head -2
else
    echo "  ✗ NO encontrada"
fi

echo ""
echo "5. TPL Memo v3: 84XECa2ahfkNNYBj21kgvVs9BfqtvsFgUKSsbjpVEzGe"
COUNT=$(grep -rn "84XECa2ahfkNNYBj21kgvVs9BfqtvsFgUKSsbjpVEzGe" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | wc -l)
if [ "$COUNT" -gt 0 ]; then
    echo "  ✓ Encontrada en $COUNT ubicaciones"
    grep -rn "84XECa2ahfkNNYBj21kgvVs9BfqtvsFgUKSsbjpVEzGe" . --exclude-dir=target --exclude-dir=.git 2>/dev/null | head -2
else
    echo "  ✗ NO encontrada"
fi
