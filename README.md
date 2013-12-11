asm_tanka
=========

このリポジトリについて
----------------------

[アセンブリ短歌](http://kozos.jp/asm-tanka/)のサンプルソースコードです。

アセンブリ短歌とは機械語命令の切れ目をうまいこと五・七・五・七・七の並びにしたバイナリコードのことであり、「近未来の文化的趣味」(上記URLの解説から引用)です。

このリポジトリには、試しにアセンブリ短歌となるよう作成してみたアセンブリ言語のソースコードを置いています。

このソースコードは、自身のバイナリコードを出力するアセンブリ言語プログラムになっています。

コンパイル方法
--------------

以下の手順でコンパイルします。tanka.sがアセンブリ短歌の実体で、main.cは単にアセンブリ短歌のコードを呼び出すためのスタブとなっています。

    $ gcc main.c taka.s

アセンブリ短歌(のコード解説)と実行例
------------------------------------

作成したアセンブリ短歌の解説も兼ねた、コンパイルと実行例を示します。
動作確認は[NetBSD-6.1-i386](http://wiki.NetBSD.org/ports/i386/)の環境で行っています。それ以外の環境では、うまく動作しない場合があるかもしれません。

先述の「コンパイル方法」で実行ファイル(a.out)が生成されます。
objdump -dで逆アセンブルして機械語命令とアセンブリ言語の対応を見てみます。
(a.outはデフォルトファイル名として扱われるので、実は省略可能です)

    $ objdump -d a.out | less

例えば、func()は以下の逆アセンブル結果になります。
機械語命令の対応を見ると、"mov $0x80486bc,%ecx"で5命令、"mov $0x64,%al","mov %ecx,%ebx","push %eax"と"nop"が2つで合計7命令になっています。

以降の機械語命令列も同じように切り分けられ、ちょうど五・七・五・七・七の並びになります。

    080486bc <func>:
     80486bc:       b9 bc 86 04 08          mov    $0x80486bc,%ecx
     80486c1:       b0 64                   mov    $0x64,%al
    080486c3 <f1>:
     80486c3:       89 cb                   mov    %ecx,%ebx
     80486c5:       50                      push   %eax
     80486c6:       90                      nop
     80486c7:       90                      nop
     80486c8:       e8 0e 00 00 00          call   80486db <my_hexdump>
     80486cd:       b0 20                   mov    $0x20,%al
     80486cf:       e8 44 00 00 00          call   8048718 <my_putchar>
     80486d4:       58                      pop    %eax
     80486d5:       41                      inc    %ecx
     80486d6:       fe c8                   dec    %al
     80486d8:       75 e9                   jne    80486c3 <f1>
     80486da:       c3                      ret
    
このサンプルでは、以下の順番で関数を呼び出しています。
main()以外の関数はアセンブリ言語で実装しています。

    main() -> func() -> my_hexdump() -> my_put_lower_bit()
                           `----> my_putchar() <---'

また、func(),my_hexdump(),my_put_lower_bit()の3つはアセンブリ短歌となっています。
(my_hexdump()は字余り...)

生成されたa.outを実行してみます。

    $ ./a.out
    b9 bc 86 04 08 b0 64 89 cb 50 90 90 e8 0e 00 00 00 b0 20 e8 46 00 00 00 58 41 fe c8 75 e9 c3 8b 13 c1 fa 04 b8 ac 86 04 08 90 90 66 83 e2 0f 90 66 01 d0 8b 00 90 90 e8 22 00 00 00 eb 01 c3 8b 13 83 e2 0f b8 ac 86 04 08 90 90 66 01 d0 8b 00 e8 09 00 00 00 eb e7 90 90 90 90 90 90 90 83 ec 10 89 04 24

16進値らしき値が出力されます。先ほどのobjdump -dの結果と照らし合わせてみます。
func()の先頭アドレスからの機械語命令の16進ダンプであることが分かります。

    $ objdump -d a.out | grep -A20 '<func>:'
    080486bc <func>:
     80486bc:       b9 bc 86 04 08          mov    $0x80486bc,%ecx
     80486c1:       b0 64                   mov    $0x64,%al
    080486c3 <f1>:
     80486c3:       89 cb                   mov    %ecx,%ebx
     80486c5:       50                      push   %eax
     80486c6:       90                      nop
     80486c7:       90                      nop
     80486c8:       e8 0e 00 00 00          call   80486db <my_hexdump>
     80486cd:       b0 20                   mov    $0x20,%al
     80486cf:       e8 46 00 00 00          call   804871a <my_putchar>
     80486d4:       58                      pop    %eax
     80486d5:       41                      inc    %ecx
     80486d6:       fe c8                   dec    %al
     80486d8:       75 e9                   jne    80486c3 <f1>
     80486da:       c3                      ret
    080486db <my_hexdump>:
     80486db:       8b 13                   mov    (%ebx),%edx
     80486dd:       c1 fa 04                sar    $0x4,%edx

