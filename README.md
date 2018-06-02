# Perl-Monad
Perl5でモナド的な便利なヤツを作りたい

# 関数・メソッド
## unit
値を受け取り、該当するモナドの最小の文脈に入れて返します。  
`Haskell`の`return`に相当しますが、実装はメソッドとなっています。

例えば、`Maybe`モナドでは`unit`は`just`関数のメソッド版です。
## map
動作自体は基本的にperlの`map`と変わりません。  
`Haskell`の`fmap`に相当しますが、実装はメソッドとなっています。  
異なる点は以下の通りです。
- 対象データ構造がリストではなく(何らかの)モナド
- 関数ではなくメソッド

例えば、`Maybe`モナドでは`map`は以下のように動作します。
```perl
use Monad::Maybe qw/just nothing/;

sub add10 { $_[0] + 10 }

(just 30)->map(\&add10);  # -> just 40
noting->map(\&add10);     # -> nothing
```

## flatmap
普通の値をモナド値に変換する関数を引数にとり、モナド値にその関数を適用しますが、
モナドの規則によりモナドのネストを解消します。  
`Haskell`の`>>=`に相当しますが、実装はメソッドとなっています。

例えば、`Maybe`モナドでは`flatmap`は以下のように動作します。
```perl
use Monad::Maybe qw/just nothing to_maybe/;

# 安全に割り算を行う
# 分母が0ならnothing、それ以外なら割り算の結果をjustにくるんで返す
sub safe_divide {
  my ($x, $y) = @_;
  to_maybe { $x / $y };
}

(just 30)->flatmap(sub { safe_divide(shift, 10) });   # -> just 10
(just 30)->flatmap(sub { safe_divide(shift,  0) });   # -> nothing

nothing->flatmap(sub { safe_divide(shift, 10) });     # -> nothing
nothing->flatmap(sub { safe_divide(shift,  0) });     # -> nothing
```

## Monad::do_monad
同じ種類のモナドを糊付けします。
`Haskell`の`do`に相当します(これは関数です)。
以下のように使います。
```perl
use Monad::Maybe qw/just nothing to_maybe/;

sub safe_divide {
  my ($x, $y) = @_;
  to_maybe { $x / $y };
}

my $result1 = do_monad 'Monad::Maybe' => (
  x => sub { safe_divide(100, 20) },    # -> just 5 
  y => sub { safe_divide(200, 10) },    # -> just 20
  sub { $_->{x} + $_->{y} }             # -> $_->{XXX}はXXX => sub { ... }に対応
);

# 上のdo_monadは、以下の動作と同じ
my $result2 =
  safe_divide(100, 20)->flatmap(sub { my $x = shift;
    safe_divide(200, 10)->flatmap(sub { my $y = shift;
      Monad::Maybe->unit($x + $y);
    });
  });

```

# Lazy
遅延評価するモナド
# Maybe
値が存在しない可能性を表現するモナド


# テスト
```
prove -lr -It/lib/ t/
```
