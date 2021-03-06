﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Вызывает принудительное заполнение всех параметров работы для текущей версии расширений.
Процедура ЗаполнитьВсеПараметрыРаботыРасширений() Экспорт
	// Заполнить идентификаторы объектов метаданных расширений.
	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) Тогда
		Обновить = Справочники.ИдентификаторыОбъектовРасширений.ИдентификаторыОбъектовТекущейВерсииРасширенийЗаполнены();
		БазоваяПодсистемаСерверПовтИсп.ИдентификаторыОбъектовМетаданныхПроверкаИспользования(Истина, Истина);
	Иначе
		Обновить = Истина;
	КонецЕсли;

	Если Обновить Тогда
		Справочники.ИдентификаторыОбъектовРасширений.ОбновитьДанныеСправочника();
	КонецЕсли;

	ИнтеграцияПодсистемСервер.ПриЗаполненииВсехПараметровРаботыРасширений();
КонецПроцедуры

// Вызывает принудительную очистку всех параметров работы для текущей версии расширений.
// Очищаются только регистры, справочники не изменяются. Вызывается, чтобы вызвать
// перезаполнение параметров работы расширений, например, при использовании параметра
// запуска ЗапуститьОбновлениеИнформационнойБазы.
//
// Общий регистр ПараметрыРаботыВерсийРасширений очищается автоматически. Если используются
// собственные регистры сведений, которых хранят версии кэшей объектов метаданных расширений,
// тогда требуется подключиться к событию ПриОчисткеВсехПараметровРаботыРасширений
// общего модуля ИнтеграцияПодсистемСервер.
//
Процедура ОчиститьВсеПараметрыРаботыРасширений() Экспорт
	УстановитьПривилегированныйРежим(Истина);

	НачатьТранзакцию();
	Попытка
		НаборЗаписей						= РегистрыСведений.ИдентификаторыОбъектовВерсийРасширений.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВерсияРасширений.Установить(ПараметрыСеанса.ВерсияРасширений);
		НаборЗаписей.ОбменДанными.Загрузка	= Истина;
		НаборЗаписей.Записать();

		НаборЗаписей						= СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ВерсияРасширений.Установить(ПараметрыСеанса.ВерсияРасширений);
		НаборЗаписей.ОбменДанными.Загрузка	= Истина;
		НаборЗаписей.Записать();

		ИнтеграцияПодсистемСервер.ПриОчисткеВсехПараметровРаботыРасширений();

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецЕсли