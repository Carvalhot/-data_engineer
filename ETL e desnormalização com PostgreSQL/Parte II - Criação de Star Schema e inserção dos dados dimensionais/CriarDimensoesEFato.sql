create schema Dimensional

create table dimensional.DimensaoVendedor(
chave_vendedor SERIAL primary key,
id_vendedor int,
nome varchar(50),
data_inicio_validade date not null,
data_fim_validade date
);

create table dimensional.DimensaoCliente(
chave_cliente SERIAL primary key,
id_cliente int,
cliente varchar(50),
estado varchar(2),
sexo varchar (1),
status varchar(50),
data_inicio_validade date not null,
data_fim_validade date
);

create table dimensional.DimensaoProduto(
chave_produto SERIAL primary key,
id_produto int,
produto varchar(100),
data_inicio_validade date not null,
data_fim_validade date
);

create table dimensional.DimensaoTempo( 
chave_tempo SERIAL primary key,
data_completa date,
dia int, 
mes int, 
ano int, 
dia_semana int, 
trimestre int
);

create table dimensional.FatoVendas(
chave_vendas SERIAL primary key,
chave_vendedor int references dimensional.DimensaoVendedor(chave_vendedor),
chave_cliente int references dimensional.DimensaoCliente(chave_cliente),
chave_produto int references dimensional.DimensaoProduto(chave_produto),
quantidade int,
valor_unitario numeric(10,2),
valor_total numeric(10,2),
desconto numeric(10,2)
);
