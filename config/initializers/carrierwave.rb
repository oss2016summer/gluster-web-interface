# Allow non-ascii letters in uploaded filenames
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/