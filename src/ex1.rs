use std::iter::{AdditiveIterator, range};

fn by_three_or_five(max: int) -> int {
  range(1, max)
    .filter(|i| i % 3 == 0 || i % 5 == 0)
    .sum()
}

#[test]
fn test_by_three_or_five() {
  assert_eq!(23, by_three_or_five(10));
  assert_eq!(233168, by_three_or_five(1000));
}
