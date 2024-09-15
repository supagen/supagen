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
    final stringDataTypes = [
      'text',
      'character varying',
    ];

    if (stringDataTypes.contains(this)) {
      return 'String';
    }

    final intDataTypes = [
      'bigint',
      'integer',
    ];

    if (intDataTypes.contains(this)) {
      return 'int';
    }

    final boolDataTypes = [
      'boolean',
    ];

    if (boolDataTypes.contains(this)) {
      return 'bool';
    }

    final decimalDataTypes = [
      'real',
    ];

    if (decimalDataTypes.contains(this)) {
      return 'double';
    }

    final dateTimeDataTypes = [
      'timestamp',
      'date',
      'time',
      'timestamp with time zone',
      'timestamp without time zone',
    ];

    if (dateTimeDataTypes.contains(this)) {
      // TODO: Implement DateTime converter
      // return 'DateTime';
      return 'String';
    }

    return 'dynamic';
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
