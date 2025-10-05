import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

// Classe para representar o resultado da validação de imagem
class ImageValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, dynamic>? imageInfo;

  ImageValidationResult({
    required this.isValid,
    this.errorMessage,
    this.imageInfo,
  });
}

class AvatarStorageService {
  static const String _avatarFolderName = 'character_avatars';
  
  // Limites para validação de imagem
  static const int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int _minImageSize = 100; // 100x100 pixels mínimo
  static const int _maxImageSize = 2048; // 2048x2048 pixels máximo
  static const List<String> _allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
  
  // Valida se a imagem atende aos critérios
  static Future<ImageValidationResult> validateImage(XFile imageFile) async {
    try {
      print('🔍 AvatarService: Iniciando validação da imagem...');
      
      // Verifica o tamanho do arquivo
      final fileSize = await imageFile.length();
      print('🔍 AvatarService: Tamanho do arquivo: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');
      
      if (fileSize > _maxFileSizeBytes) {
        print('🔍 AvatarService: Arquivo muito grande - ${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB > 5MB');
        return ImageValidationResult(
          isValid: false,
          errorMessage: 'Imagem muito grande. Máximo: 5MB\nTamanho atual: ${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB',
        );
      }
      
      // Para web, usar o tipo MIME em vez da extensão do arquivo
      if (kIsWeb) {
        print('🔍 AvatarService: Plataforma WEB - usando validação por MIME type');
        final mimeType = imageFile.mimeType?.toLowerCase() ?? '';
        print('🔍 AvatarService: MIME type: $mimeType');
        
        // Validação por MIME type para web
        final allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/webp'];
        
        if (mimeType.isEmpty || !allowedMimeTypes.contains(mimeType)) {
          print('🔍 AvatarService: MIME type não suportado - $mimeType');
          // Para web, se não conseguir detectar o MIME type, aceita se o tamanho for válido
          if (mimeType.isEmpty && fileSize > 0 && fileSize < _maxFileSizeBytes) {
            print('🔍 AvatarService: MIME type vazio mas arquivo válido - permitindo');
            return ImageValidationResult(
              isValid: true,
              imageInfo: {
                'size': fileSize,
                'mimeType': 'unknown',
                'platform': 'web',
                'note': 'MIME type não detectado, mas arquivo parece válido',
              },
            );
          }
          
          return ImageValidationResult(
            isValid: false,
            errorMessage: 'Formato não suportado.\nUse: JPG, PNG ou WEBP\nDetectado: ${mimeType.isEmpty ? 'desconhecido' : mimeType}',
          );
        }
        
        return ImageValidationResult(
          isValid: true,
          imageInfo: {
            'size': fileSize,
            'mimeType': mimeType,
            'platform': 'web',
            'recommendedSize': 'Para melhor qualidade, use imagens entre ${_minImageSize}x$_minImageSize e ${_maxImageSize}x$_maxImageSize pixels',
          },
        );
      }
      
      // Para mobile/desktop, verifica a extensão do arquivo
      final extension = path.extension(imageFile.path).toLowerCase();
      print('🔍 AvatarService: Extensão do arquivo: $extension');
      
      if (!_allowedExtensions.contains(extension)) {
        print('🔍 AvatarService: Formato não suportado - $extension');
        return ImageValidationResult(
          isValid: false,
          errorMessage: 'Formato não suportado.\nUse: JPG, PNG ou WEBP\nDetectado: $extension',
        );
      }
      
      // Para mobile/desktop, valida dimensões básicas
      print('🔍 AvatarService: Plataforma NATIVA - validação completa');
      return ImageValidationResult(
        isValid: true,
        imageInfo: {
          'size': fileSize,
          'extension': extension,
          'platform': 'native',
          'minSize': _minImageSize,
          'maxSize': _maxImageSize,
          'recommendation': 'Recomendado: imagens quadradas entre ${_minImageSize}x$_minImageSize e ${_maxImageSize}x$_maxImageSize pixels',
        },
      );
      
    } catch (e) {
      print('🔍 AvatarService ERRO na validação: $e');
      return ImageValidationResult(
        isValid: false,
        errorMessage: 'Erro ao validar imagem: $e',
      );
    }
  }
  
  // Obtém o diretório onde as imagens de avatar serão armazenadas
  static Future<Directory> _getAvatarDirectory() async {
    if (kIsWeb) {
      // Para web, usar um diretório simulado (não há diretório real no web)
      // Retornamos um diretório temporário que simula o comportamento
      print('🔍 AvatarService: Plataforma WEB - usando armazenamento simulado');
      return Directory('/web_avatar_storage'); // Diretório virtual para web
    } else {
      // Para mobile/desktop, usa o diretório de documentos da aplicação
      Directory appDir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory(path.join(appDir.path, _avatarFolderName));
      
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }
      
      return avatarDir;
    }
  }
  
  // Salva uma imagem de avatar e retorna o caminho
  static Future<String?> saveAvatarImage(XFile imageFile, String characterId) async {
    try {
      print('💾 AvatarService: Iniciando salvamento da imagem...');
      
      if (kIsWeb) {
        // Para web, criar um caminho simulado usando o blob URL original
        // No web, vamos usar o próprio path do XFile como referência
        final webPath = 'web_avatar_${characterId}_${DateTime.now().millisecondsSinceEpoch}';
        print('💾 AvatarService: WEB - Usando caminho simulado: $webPath');
        print('💾 AvatarService: WEB - Blob original: ${imageFile.path}');
        
        // Para web, retornamos o path original do blob que já pode ser usado
        return imageFile.path;
      } else {
        // Para mobile/desktop, salva fisicamente o arquivo
        final avatarDir = await _getAvatarDirectory();
        final fileExtension = path.extension(imageFile.path);
        final fileName = '${characterId}_avatar$fileExtension';
        final targetPath = path.join(avatarDir.path, fileName);
        
        print('💾 AvatarService: NATIVO - Salvando em: $targetPath');
        
        final file = File(imageFile.path);
        await file.copy(targetPath);
        
        return targetPath;
      }
    } catch (e) {
      print('💾 AvatarService ERRO ao salvar avatar: $e');
      return null;
    }
  }
  
  // Obtém uma imagem de avatar a partir do caminho
  static Future<File?> getAvatarFile(String avatarPath) async {
    try {
      final file = File(avatarPath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      print('Erro ao obter avatar: $e');
      return null;
    }
  }
  
  // Deleta uma imagem de avatar
  static Future<bool> deleteAvatarImage(String avatarPath) async {
    try {
      final file = File(avatarPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao deletar avatar: $e');
      return false;
    }
  }
  
  // Seleciona uma imagem da galeria ou câmera
  static Future<XFile?> pickAvatarImage({bool fromCamera = false}) async {
    try {
      print('🎯 AvatarService: Iniciando seleção ${fromCamera ? 'da câmera' : 'da galeria'}');
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: _maxImageSize.toDouble(),
        maxHeight: _maxImageSize.toDouble(),
        imageQuality: 80,
      );
      
      if (image != null) {
        print('🎯 AvatarService: Imagem selecionada com sucesso: ${image.path}');
        final fileSize = await image.length();
        print('🎯 AvatarService: Tamanho do arquivo: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB');
      } else {
        print('🎯 AvatarService: Nenhuma imagem foi selecionada');
      }
      
      return image;
    } catch (e) {
      print('🎯 AvatarService ERRO ao selecionar imagem: $e');
      return null;
    }
  }
  
  // Limpa todos os avatares (para limpeza/debug)
  static Future<bool> clearAllAvatars() async {
    try {
      final avatarDir = await _getAvatarDirectory();
      if (await avatarDir.exists()) {
        await avatarDir.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao limpar avatares: $e');
      return false;
    }
  }
  
  // Obtém informações sobre os requisitos de imagem
  static Map<String, dynamic> getImageRequirements() {
    return {
      'maxFileSize': _maxFileSizeBytes,
      'maxFileSizeMB': _maxFileSizeBytes / (1024 * 1024),
      'minImageSize': _minImageSize,
      'maxImageSize': _maxImageSize,
      'allowedExtensions': _allowedExtensions,
      'recommendedFormat': 'JPG ou PNG',
      'recommendedSize': '${_minImageSize}x$_minImageSize até ${_maxImageSize}x$_maxImageSize pixels',
    };
  }
}