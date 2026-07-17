const String bgRemovalPrompt = '''
Precisely remove the entire background from the image.
Isolate the primary subject (person, animal, or object) only.
Preserve all fine details including hair, fur, whiskers, and sharp edges.
Do not add, replace, blur, recolor, resize, or modify any part of the subject.
Do not crop the image.
Return the final result with a transparent background in PNG format.
Output only the final image with no additional text.
''';

const String oldPhotoRestorePrompt = '''
Carefully restore the provided old or damaged photograph.
Remove scratches, dust, cracks, stains, and visual noise.
Correct fading and color imbalance while preserving original tones.
Maintain authentic facial features, age lines, textures, and details.
Do not beautify, stylize, modernize, or modify the subject.
Do not add, remove, or replace any objects or background elements.
Preserve the original framing, proportions, and realism.
Return only the restored image with no additional text.
''';

const String imageEnhancePrompt =
    "You are an advanced image restoration and super-resolution model. "
    "This image was captured using an old low-quality phone camera and contains heavy blur, pixelation, motion artifacts, and compression damage. "
    "Actively reconstruct the image by performing super-resolution upscaling, rebuilding lost facial details such as eyes, lips, nose, and skin texture, removing pixelation, blur, and color bleeding, correcting distorted edges and noise, and improving clarity to modern HD quality. "
    "Preserve the original person’s identity, facial proportions, expression, and color tones. "
    "Do not beautify, stylize, cartoonize, or artistically modify the image. "
    "Do not change makeup style, facial structure, or lighting intent. "
    "Do not add or remove any elements. "
    "The result should look like the same photo captured clearly with a modern smartphone camera. "
    "Output only the enhanced image.";

const String faceSwapPrompt = '''
Swap the face in the source image with the target face provided.
Maintain the lighting, skin tone, and expression of the source image.
Ensure the face swap looks realistic and seamless.
Output only the final image with no additional text.
''';

/// Wraps a raw template prompt into a descriptive style optimized for Pollinations AI.
String buildTemplatePrompt(String rawPrompt) {
  return "photorealistic, $rawPrompt, highly detailed, 8k resolution, professional lighting, cinematic composition, masterpiece";
}
