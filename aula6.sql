create database bd_aula06;
\c bd_aula06
create domain chk_categoria text check (value='DRAMA' or value='COMEDIA');
create domain chk_status text check (value='DISPONIVEL' or value='ALUGADO');
create table tbl_cliente (codigo_cliente integer PRIMARY KEY, nome text not null, cidade text, endereco text);
create table tbl_titulo (codigo_titulo integer primary key, titulo text not null, descricao text, categoria chk_categoria);
create table tbl_livros (cod_livro integer PRIMARY KEY, codigo_titulo integer REFERENCES tbl_titulo(codigo_titulo), status chk_status DEFAULT 'DISPONIVEL');
create table tbl_emprestimo (numero_emprestimo integer PRIMARY KEY, codigo_cliente integer REFERENCES tbl_cliente(codigo_cliente), codigo_livro integer REFERENCES tbl_livros(cod_livro));
-- Inserir dados na tabela tbl_cliente
INSERT INTO tbl_cliente (codigo_cliente, nome, cidade, endereco)
VALUES
    (1, 'Joao Silva', 'Sao Paulo', 'Rua A, 123'),
    (2, 'Maria Santos', 'Rio de Janeiro', 'Av. B, 456'),
    (3, 'Pedro Almeida', 'Belo Horizonte', 'Rua C, 789'),
    (4, 'Ana Oliveira', 'Salvador', 'Av. D, 1011'),
    (5, 'Carlos Lima', 'Brasília', 'Rua E, 1213');
-- Inserir dados na tabela tbl_titulo
INSERT INTO tbl_titulo (codigo_titulo, titulo, descricao, categoria)
VALUES
    (1, 'Aventuras Urbanas', 'Uma história emocionante', 'DRAMA'),
    (2, 'Mistérios Antigos', 'Enigmas por resolver', 'COMEDIA'),
    (3, 'Amor nas Estrelas', 'Um romance intergaláctico', 'DRAMA'),
    (4, 'Código Enigmatico', 'Segredos ocultos', 'COMEDIA'),
    (5, 'Histórias Perdidas', 'Contos esquecidos', 'DRAMA');
-- Inserir dados na tabela tbl_livros
INSERT INTO tbl_livros (cod_livro, codigo_titulo, status)
VALUES
    (1, 1, 'ALUGADO'),
    (2, 1, 'ALUGADO'),
    (3, 2, 'DISPONIVEL'),
    (4, 3, 'ALUGADO'),
    (5, 4, 'ALUGADO');
-- Inserir dados na tabela tbl_emprestimo
INSERT INTO tbl_emprestimo (numero_emprestimo, codigo_cliente, codigo_livro)
VALUES
    (1, 1, 2),
    (2, 2, 4),
    (3, 3, 1),
    (4, 4, 5);

--Liste os títulos e seus status, incluindo os que não têm status definido
SELECT l.titulo, l.descricao ,livros.status FROM tbl_titulo l 
FULL JOIN tbl_livros AS livros ON livros.codigo_titulo = l.codigo_titulo;

--Liste os títulos e suas descrições dos livros alugados
SELECT l.titulo, l.descricao FROM tbl_titulo l 
LEFT JOIN tbl_livros AS livros ON livros.codigo_titulo = l.codigo_titulo WHERE livros.status = 'ALUGADO';
--Liste os nomes dos clientes que não têm livros alugados
SELECT C.nome FROM tbl_cliente AS C 
LEFT JOIN tbl_emprestimo AS E ON C.codigo_cliente = E.codigo_cliente
WHERE E.numero_emprestimo is null;

--Liste os títulos e suas categorias dos livros disponiveis
SELECT t.titulo,t.categoria from tbl_titulo t 
INNER JOIN tbl_livros l ON l.codigo_titulo = t.codigo_titulo
WHERE l.status = 'DISPONIVEL';



--Liste os nomes dos clientes e os títulos dos livros que eles têm alugados
SELECT C.nome,T.titulo FROM tbl_cliente AS C 
LEFT JOIN tbl_emprestimo AS E ON C.codigo_cliente = E.codigo_cliente
LEFT JOIN tbl_titulo as T ON E.codigo_livro = T.codigo_titulo;


--Retorne o nome, titulo do livro e o status do esmprestimo do livro alugado pela Ana Oliveira
SELECT C.nome,T.titulo,L.status from tbl_emprestimo as E 
LEFT JOIN tbl_cliente as C ON C.codigo_cliente = E.codigo_cliente 
INNER JOIN tbl_livros as L ON E.codigo_livro = L.cod_livro
INNER JOIN tbl_titulo as T on T.codigo_titulo = L.codigo_titulo
WHERE C.nome = 'Ana Oliveira';
