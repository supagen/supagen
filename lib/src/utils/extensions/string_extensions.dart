extension NullableStringExtensions on String? {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    }

    return this!.trim().isEmpty;
  }
}

extension StringExtensions on String {
  String toDartDataType() {
    final dataTypes = <List<String>, String>{
      [
        // strings
        'text',
        'character varying',
        'character',
        'bytea',
        'uuid',
        'tsvector',
        // date times
        'timestamp',
        'date',
        'time',
        'time with time zone',
        'timestamp with time zone',
        'timestamp without time zone'
      ]: 'String',
      ['bigint', 'integer', 'smallint']: 'int',
      ['boolean']: 'bool',
      ['real', 'numeric', 'double precision']: 'double',
      ['jsonb', 'json']: 'Map<String, dynamic>',
    };

    if (contains('[]')) {
      return 'List<${dataTypes.entries.firstWhere((element) => element.key.contains(replaceAll('[]', '')), orElse: () => MapEntry([], 'dynamic')).value}>';
    }

    return dataTypes.entries
        .firstWhere((element) => element.key.contains(this),
            orElse: () => MapEntry([], 'dynamic'))
        .value;
  }

  String dynamicToDartDataType() {
    final dataTypes = <String, String>{
      'string': 'String',
      'number': 'double',
      'integer': 'int',
      'boolean': 'bool',
      'array': 'List<dynamic>',
    };

    return dataTypes[this] ?? 'dynamic';
  }

  // Make the string singular
  String get singularize {
    final plural = this;

    if (plural.endsWith('ies')) {
      return plural.replaceAll(RegExp(r'ies$'), 'y');
    }

    if (plural.endsWith('s')) {
      return plural.replaceAll(RegExp(r's$'), '');
    }

    return plural;
  }

  // Make the string camelCase
  String get toCamelCase {
    final parts = split('_');
    final first = parts.first;
    final rest = parts.sublist(1);

    final camelCase = rest.fold(first, (previousValue, element) {
      return previousValue + element.capitalize;
    });

    return camelCase;
  }

  // Make the string capitalize
  String get capitalize {
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
