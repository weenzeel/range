import 'package:grizzly_range/grizzly_range.dart';
import 'package:quiver_hashcode/hashcode.dart';

/// Encloses an extent with a [lower] limit and [upper] limit, both inclusive
///
///     final extent = Extent<int>(5, 10);
class Extent<E> {
  /// Inclusive lower limit of the extent
  final E lower;

  /// Inclusive upper limit of the extent
  final E upper;

  /// Creates an extent with [lower] limit and [upper] limit
  const Extent(this.lower, this.upper);

  /// Returns limit as [List]
  List<E> asList() => <E>[lower, upper];

  /// Compares if [this] and [other] are equal
  bool operator ==(other) {
    if (other is Extent<E>) {
      if (other.lower != lower) return false;
      if (other.upper != upper) return false;
      return true;
    } else if (other is Iterable<E>) {
      if (other.length != 2) return false;
      if (other.elementAt(0) != lower) return false;
      if (other.elementAt(1) != upper) return false;
      return true;
    }
    return false;
  }

  @override
  int get hashCode => hash2(lower, upper);

  Iterable<E> range(step) {
    if (E == int) {
      return IntRange(lower as int, upper as int, step) as Iterable<E>;
    } else if (E == double) {
      return DoubleRange(lower as double, upper as double, step) as Iterable<E>;
    } else if (E == DateTime) {
      if (step is Duration) {
        return TimeRange(lower as DateTime, upper as DateTime, step)
            as Iterable<E>;
      } else if (step is int) {
        return MonthRange(lower as DateTime, upper as DateTime, step)
            as Iterable<E>;
      } else {
        throw UnsupportedError(
            'step must be int or Duration for time range. but found $E');
      }
    }

    throw UnsupportedError("range is not supported for $E");
  }

  /// Computes an [Extent] from given [data] by finding the minimum and maximum.
  ///
  /// If E is [Comparable], [E.compareTo] is used for comparision. Otherwise,
  /// [comparator] argument is required.
  static Extent<E> compute<E>(Iterable<E> data, [Comparator<E> comparator]) {
    comparator ??= (a, b) => (a as Comparable).compareTo(b);
    E min;
    E max;
    for (E d in data) {
      if (d == null) continue;

      if (max == null || comparator(d, max) > 0) max = d;
      if (min == null || comparator(d, min) < 0) min = d;
    }
    return Extent<E>(min, max);
  }

  String toString() => 'Extent [$lower, $upper]';
}
