﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	НастроитьПорядокГруппыВсеПользователи(Список);

	Если Параметры.РежимВыбора Тогда
		БазоваяПодсистемаСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна	= РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;

		// Исключение выбора группы Все внешние пользователи в качестве родителя.
		БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", Справочники.ГруппыПользователей.ВсеПользователи, ВидСравненияКомпоновкиДанных.НеРавно, , Параметры.Свойство("ВыборРодителя"));

		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Заголовок							= "Подбор групп пользователей";
			Элементы.Список.МножественныйВыбор	= Истина;
			Элементы.Список.РежимВыделения		= РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок							= "Выбор группы пользователей";
		КонецЕсли;

		АвтоЗаголовок				= Ложь;
	Иначе
		Элементы.Список.РежимВыбора	= Ложь;
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьПорядокГруппыВсеПользователи(Список)
	Перем Порядок;

	// Порядок.
	Порядок											= Список.КомпоновщикНастроек.Настройки.Порядок;
	Порядок.ИдентификаторПользовательскойНастройки	= "ОсновнойПорядок";
	Порядок.Элементы.Очистить();

	ЭлементПорядка						= Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле					= Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания	= НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование		= Истина;

	ЭлементПорядка						= Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле					= Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания	= НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование		= Истина;
КонецПроцедуры
