import 'dart:math';

/// A small double value, used to ensure that comparisons between double are
/// valid.
const defaultEpsilon = 1 / 1000;

// Method to convert degrees to radians
double degToRad(double deg) => deg * (pi / 180.0);
