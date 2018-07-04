package com.typelead.intellij.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

public class NonEmptyList<A> {

  private final List<A> list;

  private NonEmptyList(List<A> list) {
    this.list = list;
  }

  public static <A> NonEmptyList<A> of(A head, A... tail) {
    ArrayList<A> list = new ArrayList<>(tail.length + 1);
    list.set(0, head);
    for (int i = 0; i < tail.length; i++) {
      list.set(i + 1, tail[i]);
    }
    return new NonEmptyList<>(list);
  }

  public static <A> NonEmptyList<A> fromList(List<A> list) {
    if (list.isEmpty()) throw new IllegalArgumentException("Unexpected empty list");
    return new NonEmptyList<>(list);
  }

  public A getHead() {
    return list.get(0);
  }

  public List<A> getTail() {
    ArrayList<A> xs = new ArrayList<>(list);
    xs.remove(0);
    return xs;
  }

  public List<A> toList() {
    return new ArrayList<>(list);
  }

  public <B> NonEmptyList<B> map(Function<A, B> f) {
    return new NonEmptyList<>(list.stream().map(f).collect(Collectors.toList()));
  }
}
