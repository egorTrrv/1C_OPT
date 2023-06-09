﻿
Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)
	
	ТекущийПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
	ТекущийПользователь = Справочники.Пользователи.НайтиПоРеквизиту("УникальныйИднтификаторПользователя", ТекущийПользователь);
	Если ТекущийПользователь <> Неопределено Тогда
		ПараметрыСеанса.ТекущийПользователь = ТекущийПользователь;
	Иначе
		ВызватьИсключение "Пользователь не зарегистрирован в системе! Обратитесь к администратору";
	КонецЕсли;
	
КонецПроцедуры
