use std::iter::range_step;

fn palindrome(s: ~str) -> bool {
  let chars: ~[u8] = s.bytes().collect();
  let flipped: ~[u8] = s.bytes_rev().collect();
  chars == flipped
}

fn largest_palindrome() -> int {
  let big = range_step(999,99, -1)
    .zip(range_step(999,99, -1))
    .map(|z| match z { (a,b) => a*b})
    .filter(|i| palindrome(i.to_str()))
    .nth(0);

  match big {
      Some(x) => x,
      None => 0
  }
}

#[test]
fn test_palindrome() {
  assert!(palindrome(~"racecar"));
  assert!(!palindrome(~"wrong"));
}

#[test]
fn test_largest_palindrome() {
  assert_eq!(698896, largest_palindrome());
}
