# 🔧 Debug - Sistema de Upload de Imagem

## 🚨 Problemas Identificados e Soluções

### **Problema 1: Flutter Web + image_picker**
- **Causa**: O `image_picker` no Flutter Web tem limitações
- **Sintoma**: Imagens não são selecionadas ou aparecem como null

### **Problema 2: Permissões do Navegador**
- **Causa**: Chrome pode bloquear acesso a arquivos
- **Solução**: Verificar permissões de câmera/arquivos

### **Problema 3: Tamanho e Formato**
- **Causa**: Validação muito restritiva
- **Solução**: Logs de debug implementados

## 📱 Como Testar:

### **1. Navegue para a ficha:**
```
Home → Criar Personagem → (preencha dados básicos) → Avatar
```

### **2. Tente diferentes formatos:**
- ✅ JPG/JPEG (mais compatível)
- ✅ PNG (boa opção)
- ❌ WEBP (pode ter problemas no web)

### **3. Tamanhos recomendados:**
- 📐 256x256px (ideal para testes)
- 📐 512x512px (boa qualidade)
- 🚫 Evite > 2MB

### **4. Onde encontrar imagens para teste:**
- Pasta Downloads do Windows
- Google Images → Ferramentas → Direitos de uso → Reutilização
- Selfie tirada com o celular

## 🕵️ Debug Implementado:

### **Logs no Console (F12):**
```
🎯 AvatarService: Iniciando seleção da galeria
🔍 AvatarService: Iniciando validação da imagem...
🖼️ Imagem selecionada: [path]
```

### **Como ver os logs:**
1. Abra DevTools (F12)
2. Vá na aba Console
3. Tente fazer upload
4. Observe as mensagens com emojis

## 🔧 Soluções Testadas:

### **1. Preview Melhorado:**
- Usando `Image.memory()` para web
- FutureBuilder para loading
- Tratamento de erro

### **2. Validação Relaxada:**
- Limite aumentado para 5MB
- Extensões múltiplas suportadas
- Validação específica para web

### **3. Logs Detalhados:**
- Cada etapa do processo tem logs
- Informações de tamanho e formato
- Erros específicos

## 🧪 Teste Rápido:

1. **Baixe uma imagem pequena** (< 1MB, 256x256px)
2. **Salve como JPG** na pasta Downloads
3. **Teste na ficha** → Avatar → Galeria
4. **Verifique o console** (F12) para logs

## 🚀 Próximos Passos:

Se ainda não funcionar:
1. Testar sem validação
2. Implementar upload via HTML input
3. Considerar drag & drop
4. Usar biblioteca alternativa

---
**Logs foram adicionados em:**
- `ficha_pronta.dart` (lines 695-720)
- `avatar_storage_service.dart` (lines 25-90, 160-180)