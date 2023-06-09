﻿// ТарураевЕ { 1.0.2 # 01.03.2023
Процедура СоздатьПартииДокумента(Объект) Экспорт
	
	Для Каждого СтрокаТЧ Из Объект.СтрокиЗаказа Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Партия) Тогда
			
			ПартияОбъект = Справочники.Партии.СоздатьЭлемент();
			ПартияОбъект.УстановитьНовыйКод();
			ПартияОбъект.Номенклатура = СтрокаТЧ.Номенклатура;
			ПартияОбъект.Записать();
			СтрокаТЧ.Партия = ПартияОбъект.Ссылка;
			
		КонецЕсли;
	КонецЦикла;
	Объект.Записать(РежимЗаписиДокумента.Запись);
	
Конецпроцедуры 

Процедура УдалитьПартию(СсылкаНаПартию, Статус) Экспорт
	
	Если Статус = Перечисления.СтатусыЗаказов.Завершен Тогда	
		Сообщить("Заказ завершён, партия не может быть удалена!");
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	// Очистить двжиения
	НовыйНаборЗаписей = РегистрыНакопления.Товары.СоздатьНаборЗаписей();
	НовыйНаборЗаписей.Отбор.Партия.Установить(СсылкаНаПартию);
	НовыйНаборЗаписей.Записать();
	
	ПартияОбъект = СсылкаНаПартию.ПолучитьОбъект();	
	
	ПартияОбъект.Удалить();
	УстановитьПривилегированныйРежим(Ложь);
	
Конецпроцедуры    
// }Тарураев