<?php

function MakeOffer($id_user, $amount, $gifts)
{
	echo('MakeOffer(' . $id_user . ', ' . $amount . ', [');
	echo(implode(",", $gifts));
	echo('])');
}

function Favorite($id_user, $on_off)
{
	echo('Favorite(' . $id_user . ', ' . $on_off . ']');
}

if ($_POST['MakeOffer'] != '') {
	MakeOffer($_POST['MakeOffer']['id_user'], $_POST['MakeOffer']['amount'], $_POST['MakeOffer']['gifts']);
}
if ($_POST['Favorite'] != '') {
	Favorite($_POST['Favorite']['id_user'], $_POST['Favorite']['on_off']);
}

?>