use std::cmp::max;
use std::iter::range_inclusive;

fn largest_prime_factor(n: int, current: int) -> int {
  for i in range_inclusive(2, n) {
    if n % i == 0 {
      return largest_prime_factor(n/i, max(i, current));
    }
  }

  return current;
}

#[test]
fn test_largest_prime_factor() {
  assert_eq!(5, largest_prime_factor(10, 1));
  assert_eq!(6857, largest_prime_factor(600851475143, 1));
}
