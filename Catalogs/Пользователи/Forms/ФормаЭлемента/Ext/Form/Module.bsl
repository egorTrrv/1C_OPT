﻿
&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	
	ДанныеФИО = СтрРазделить(Объект.ФИО, " ", Истина);
	Фамилия = ?(ДанныеФИО.Количество() > 0, ДанныеФИО[0], "");;
	Имя = ?(ДанныеФИО.Количество() > 1, ДанныеФИО[1], "");;
	Отчество = ?(ДанныеФИО.Количество() > 2, ДанныеФИО[2], "");
	Объект.Наименование = Фамилия + Лев(Имя, 1) + Лев(Отчество, 1);
	
КонецПроцедуры
