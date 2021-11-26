select 
	   dimensional.dimensaocliente.cliente,
       dimensional.dimensaocliente.estado,
       dimensional.dimensaocliente.sexo,
       dimensional.dimensaocliente.status,
       dimensional.fatovendas.quantidade,
       dimensional.fatovendas.valor_unitario,
       dimensional.fatovendas.valor_total,
       dimensional.fatovendas.desconto,
       dimensional.dimensaoproduto.produto,
       dimensional.dimensaotempo.data_completa,
       dimensional.dimensaotempo.dia,
       dimensional.dimensaotempo.mes,
       dimensional.dimensaotempo.ano,
       dimensional.dimensaotempo.trimestre,
       dimensional.dimensaovendedor.nome
       
       	INTO dimensional.des_vendas
       
  from ((((dimensional.dimensaocliente
  inner join dimensional.fatovendas
       on (dimensional.fatovendas.chave_cliente = dimensional.dimensaocliente.chave_cliente))
  inner join dimensional.dimensaoproduto
       on (dimensional.dimensaoproduto.chave_produto = dimensional.fatovendas.chave_produto))
  inner join dimensional.dimensaotempo
       on (dimensional.dimensaotempo.chave_tempo = dimensional.fatovendas.chave_tempo))
  inner join dimensional.dimensaovendedor
       on (dimensional.dimensaovendedor.chave_vendedor = dimensional.fatovendas.chave_vendedor));
       
select * from dimensional.des_vendas