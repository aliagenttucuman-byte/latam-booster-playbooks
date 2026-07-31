#!/bin/bash
# Valida un playbook .md contra las reglas de nelson-latam-booster-playbook-template
# Uso: bash scripts/validate.sh repos/01-infraestructure.md

set -e

FILE=$1
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "ERROR: archivo no encontrado: $FILE"
  echo "Uso: bash scripts/validate.sh repos/0X-nombre.md"
  exit 1
fi

FAIL=0

echo "=== Validando: $FILE ==="
echo

# 1. Longitud
LINES=$(wc -l < "$FILE")
echo "1. Longitud: $LINES lineas"
if [ "$LINES" -lt 300 ]; then
  echo "   WARN: menos de 300 lineas, revisar profundidad"
  FAIL=1
elif [ "$LINES" -gt 800 ]; then
  echo "   WARN: mas de 800 lineas, ir al hueso"
  FAIL=1
else
  echo "   OK"
fi

# 2. Frontmatter YAML valido
echo "2. Frontmatter YAML:"
python3 -c "
import yaml, sys
content = open('$FILE').read()
parts = content.split('---')
if len(parts) < 3:
    print('   FAIL: no encuentra frontmatter --- ... ---')
    sys.exit(1)
try:
    yaml.safe_load(parts[1])
    print('   OK')
except yaml.YAMLError as e:
    print(f'   FAIL: {e}')
    sys.exit(1)
" || FAIL=1

# 3. Diagramas Mermaid (exactamente 3)
MERMAID=$(grep -c '```mermaid' "$FILE" || true)
echo "3. Diagramas Mermaid: $MERMAID"
if [ "$MERMAID" -ne 3 ]; then
  echo "   FAIL: debe haber exactamente 3 (contexto + pipeline + arbol pitfalls)"
  FAIL=1
else
  echo "   OK"
fi

# 4. Secciones canonicas (9 nivel 2)
SECTIONS=$(grep -c '^## ' "$FILE" || true)
echo "4. Secciones nivel 2: $SECTIONS"
if [ "$SECTIONS" -lt 9 ]; then
  echo "   FAIL: se esperan 9 secciones canonicas minimo"
  FAIL=1
elif [ "$SECTIONS" -gt 12 ]; then
  echo "   WARN: mas de 12 secciones, revisar si sobra contenido"
else
  echo "   OK"
fi

# 5. Pitfalls con fecha
PITFALLS=$(grep -cE '^### Pitfall [0-9]+ .*\([0-9]{2}-[a-zA-Z]{3}-[0-9]{4}\)' "$FILE" || true)
echo "5. Pitfalls con fecha DD-MMM-YYYY: $PITFALLS"
if [ "$PITFALLS" -lt 3 ]; then
  echo "   FAIL: minimo 3 pitfalls con fecha real"
  FAIL=1
else
  echo "   OK"
fi

# 6. Refs prohibidas (JARVIS/Honcho/skill/mini-cosmos)
FORBIDDEN=$(grep -icE 'jarvis|honcho|\bskill\b|mini-cosmos' "$FILE" || true)
echo "6. Refs prohibidas (jarvis/honcho/skill/mini-cosmos): $FORBIDDEN"
if [ "$FORBIDDEN" -gt 0 ]; then
  echo "   FAIL: encontradas refs internas prohibidas"
  grep -inE 'jarvis|honcho|\bskill\b|mini-cosmos' "$FILE" | head -5
  FAIL=1
else
  echo "   OK"
fi

# 7. TODOs / FIXMEs
TODOS=$(grep -cE 'TODO|FIXME|TBD' "$FILE" || true)
echo "7. TODO/FIXME/TBD: $TODOS"
if [ "$TODOS" -gt 0 ]; then
  echo "   FAIL: no debe quedar TODO/FIXME/TBD en un playbook publicado"
  FAIL=1
else
  echo "   OK"
fi

# 8. Bloques de codigo balanceados
CODE_BLOCKS=$(grep -c '^```' "$FILE" || true)
echo "8. Bloques de codigo (\`\`\`): $CODE_BLOCKS"
if [ $((CODE_BLOCKS % 2)) -ne 0 ]; then
  echo "   FAIL: bloques de codigo desbalanceados"
  FAIL=1
else
  echo "   OK ($((CODE_BLOCKS / 2)) bloques cerrados)"
fi

echo
if [ "$FAIL" -eq 0 ]; then
  echo "=== VALIDATION OK ==="
  exit 0
else
  echo "=== VALIDATION FAIL ==="
  exit 1
fi
