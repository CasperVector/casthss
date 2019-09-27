@default_files = ('thesis');
# 使用 xelatex 编译。
$pdf_mode = 5;
# 此选项相关说明见 texdoc latexmk。
$bibtex_use = 1.5;
$biber = "biber -l zh__pinyin --output-safechars %O %S";
# latexmk -c 时自动删除 .run.xml 文件。
@generated_exts = (@generated_exts, 'run.xml');

