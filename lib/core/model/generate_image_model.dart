import 'dart:typed_data';

/// Simplified model returned by the Pollinations.ai image API.
/// The API returns raw image bytes directly from a GET request,
/// so we store them in [imageBytes].
///
/// The legacy Gemini-style fields ([candidates], [usageMetadata], etc.)
/// are retained for backward compatibility but are no longer populated.
class GenerateImageModel {
  /// Raw PNG/JPEG bytes of the generated image.
  Uint8List? imageBytes;

  // --- Legacy Gemini fields (not used with Pollinations) ---
  List<Candidates>? candidates = [];
  UsageMetadata? usageMetadata;
  String? modelVersion;
  String? responseId;

  GenerateImageModel({
    this.imageBytes,
    this.candidates,
    this.usageMetadata,
    this.modelVersion,
    this.responseId,
  });

  GenerateImageModel.fromJson(Map<String, dynamic> json) {
    if (json['candidates'] != null) {
      candidates = <Candidates>[];
      json['candidates'].forEach((v) {
        candidates!.add(Candidates.fromJson(v));
      });
    }
    usageMetadata = json['usageMetadata'] != null
        ? UsageMetadata.fromJson(json['usageMetadata'])
        : null;
    modelVersion = json['modelVersion'];
    responseId = json['responseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (candidates != null) {
      data['candidates'] = candidates!.map((v) => v.toJson()).toList();
    }
    if (usageMetadata != null) {
      data['usageMetadata'] = usageMetadata!.toJson();
    }
    data['modelVersion'] = modelVersion;
    data['responseId'] = responseId;
    return data;
  }
}

class Candidates {
  Content? content;
  String? finishReason;
  int? index;

  Candidates({this.content, this.finishReason, this.index});

  Candidates.fromJson(Map<String, dynamic> json) {
    content = json['content'] != null
        ? Content.fromJson(json['content'])
        : null;
    finishReason = json['finishReason'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content!.toJson();
    }
    data['finishReason'] = finishReason;
    data['index'] = index;
    return data;
  }
}

class Content {
  List<Parts>? parts;
  String? role;

  Content({this.parts, this.role});

  Content.fromJson(Map<String, dynamic> json) {
    if (json['parts'] != null) {
      parts = <Parts>[];
      json['parts'].forEach((v) {
        parts!.add(Parts.fromJson(v));
      });
    }
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (parts != null) {
      data['parts'] = parts!.map((v) => v.toJson()).toList();
    }
    data['role'] = role;
    return data;
  }
}

class Parts {
  InlineData? inlineData;

  Parts({this.inlineData});

  Parts.fromJson(Map<String, dynamic> json) {
    inlineData = json['inlineData'] != null
        ? InlineData.fromJson(json['inlineData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (inlineData != null) {
      data['inlineData'] = inlineData!.toJson();
    }
    return data;
  }
}

class InlineData {
  String? mimeType;
  String? data;

  InlineData({this.mimeType, this.data});

  InlineData.fromJson(Map<String, dynamic> json) {
    mimeType = json['mimeType'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mimeType'] = mimeType;
    data['data'] = this.data;
    return data;
  }
}

class UsageMetadata {
  int? promptTokenCount;
  int? candidatesTokenCount;
  int? totalTokenCount;
  List<PromptTokensDetails>? promptTokensDetails;

  UsageMetadata({
    this.promptTokenCount,
    this.candidatesTokenCount,
    this.totalTokenCount,
    this.promptTokensDetails,
  });

  UsageMetadata.fromJson(Map<String, dynamic> json) {
    promptTokenCount = json['promptTokenCount'];
    candidatesTokenCount = json['candidatesTokenCount'];
    totalTokenCount = json['totalTokenCount'];
    if (json['promptTokensDetails'] != null) {
      promptTokensDetails = <PromptTokensDetails>[];
      json['promptTokensDetails'].forEach((v) {
        promptTokensDetails!.add(PromptTokensDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promptTokenCount'] = promptTokenCount;
    data['candidatesTokenCount'] = candidatesTokenCount;
    data['totalTokenCount'] = totalTokenCount;
    if (promptTokensDetails != null) {
      data['promptTokensDetails'] = promptTokensDetails!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class PromptTokensDetails {
  String? modality;
  int? tokenCount;

  PromptTokensDetails({this.modality, this.tokenCount});

  PromptTokensDetails.fromJson(Map<String, dynamic> json) {
    modality = json['modality'];
    tokenCount = json['tokenCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modality'] = modality;
    data['tokenCount'] = tokenCount;
    return data;
  }
}
