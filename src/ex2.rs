use std::iter::{AdditiveIterator};

struct FiboIterator {
  last: int,
  next: int
}

impl Iterator<int> for FiboIterator {

  fn next(&mut self) -> Option<int> {
    let tmp = self.last + self.next;
    self.last = self.next;
    self.next = tmp;
    Some(tmp)
  }
}

fn fibo() -> FiboIterator {
  FiboIterator { last: 0, next: 1 }
}

fn even_fibos_sum(max: int) -> int {
  fibo()
    .filter(|i| i % 2 == 0)
    .take_while(|i| i < &max)
    .sum()
}


#[test]
fn test_even_fibos_sum() {
  assert_eq!(4613732, even_fibos_sum(4000000))

}
