--Criando as tabelas do nosso schema relacional

create schema Relacional

create table Relacional.Vendedores(
	id_vendedor SERIAL primary KEY,
	Nome Varchar(100)
)


create table Relacional.Produtos(
	id_produto SERIAL primary key,
	produto varchar(100),
	preco numeric (10,2)
)

create table Relacional.Clientes(
	id_cliente SERIAL primary key,
	cliente varchar(100),
	estado varchar(2),
	sexo char(1),
	status varchar(50)
)



create table Relacional.Vendas(
	id_venda SERIAL primary key,
	id_vendedor int references Relacional.Vendedores (id_vendedor),
	id_cliente int references Relacional.Clientes (id_cliente),
	data_venda date,
	total numeric(10,2)
)


CREATE TABLE Relacional.ItensVenda (
    id_produto int REFERENCES Relacional.Produtos ON DELETE RESTRICT,
    id_venda int REFERENCES Relacional.Vendas ON DELETE CASCADE,
    quantidade int,
    valor_Unitario decimal(10,2),
    valor_Total decimal(10,2),
	desconto decimal(10,2),
    PRIMARY KEY (id_produto, id_venda)
);

