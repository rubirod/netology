//
// Домашнее задание к занятию 3.2. Протоколы и расширения
//
// Ваше ПО
// - должно подходить для любой марки авто,
// - должно быть расширяемым и масштабируемым в дальнейшем, чтобы ваша компания могла выпускать обновления.
// Задача разделена на 4 части, в каждой из них нужно самостоятельно подумать,
// - какой тип данных передать каждому свойству для комфортной работы, а также
// - по необходимости добавить вспомогательные методы.
//
import Foundation

let line = "\n" + String(repeating: "-" as Character, count: 80) + "\n"

// MARK: - расширяемость и масштабируемость

// enum не позволяет ошибиться в названии и позволяет расширять автобренды
enum CarBrands: String, CaseIterable {
    case BMW, Honda, Audi, Lexus, Volvo
}

// Палитра всех прошлых, настоящих цветов. В будущем множно добавлять новые.
enum Palette: CaseIterable {
    case red, green, blue
}

// Для аксессуаров будем использовать Set, т.к. это удобно для сравнения и дополнения.
// Задачу можно сделать веселее задав разный набор аксессуаров разным брендам и/или салонам.
let allAccessories: Set<String> = ["toning", "signaling", "sportsDiscs", "firstAidKit", "fireExtinguisher"]

// Производственные планы для заводов. Это масштабируемость
let countCarsInFactory: [CarBrands : UInt32] = [.BMW : 5, .Honda : 2, .Audi : 3, .Lexus : 3, .Volvo: 7]

// Можно задавать заводские цены и предустановленный набор акксесуаров, но без кодогенерации это уж очень много ручного труда. Надо ли?


// MARK: - Часть 1.
/*
 Создайте протокол 'Car'
 Добавьте в него свойства:
 'model' (только для чтения): марка
 'color' (только для чтения): цвет
 'buildDate' (только для чтения): дата выпуска
 'price' (чтение и запись): цена авто
 'accessories' (чтение и запись): дополнительное оборудование (тонировка, сингнализация, спортивные диски)
 'isServiced' (чтение и запись): сделана ли предпродажная подготовка. Обычно ее делают в дилерских центрах перед постановкой машины в салон.
*/
protocol Car {

    var brand: CarBrands { get }
    var color: Palette { get }
    var buildDate: Date { get }
    var price: UInt32 { get set } // без копеек обойдёмся
    var accessories: Set<String> { get set }
    var isServiced: Bool { get set }

    mutating func buyingAccessories()
}

// MARK: - Часть 2.
/*

 По аналогии с протоколом 'Car', нужно описать дилерский центр минимальным набором свойств и методов, используя протокол.

 Алгоритм выполнения

 Создайте протокол 'Dealership'
 Добавьте свойства:
 'name' (только для чтения): название дилерского центра (назвать по марке машины для упрощения)
 'showroomCapacity' (только для чтения): максимальная вместимость автосалона по количеству машин.
 'stockCars' (массив, чтение и запись): машины, находящиеся на парковке склада. Представим, что парковка не имеет лимита по количеству машин.
 'showroomCars' (массив, чтение и запись): машины, находящиеся в автосалоне.
 'cars' (массив, чтение и запись): хранит список всех машин в наличии.

 Добавьте методы:
 'offerAccesories(_ :)': принимает массив акксесуаров в качестве параметра. Метод предлагает клиенту купить доп. оборудование.
 'presaleService(_ :)': принимает машину в качестве параметра. Метод отправляет машину на предпродажную подготовку.
 'addToShowroom(_ :)': также принимает машину в качестве параметра. Метод перегоняет машину с парковки склада в автосалон, при этом выполняет предпродажную подготовку.
 'sellCar(_ :)': также принимает машину в качестве параметра. Метод продает машину из автосалона при этом проверяет, выполнена ли предпродажная подготовка. Также, если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить. (давайте представим, что клиент всегда соглашается и покупает :) )
 'orderCar()': не принимает и не возвращает параметры. Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.

 Обратите внимание! Каждый метод должен выводить в консоль информацию о машине и выполненном действии с ней.
*/
protocol Dealership {

    var name: CarBrands { get } // Название по марке машины сразу и слоган подтягивает
    var showroomCapacity: UInt16 { get } // 65_535
    var stockCars: [Car] { get set } // машины, находящиеся на парковке склада. парковка не имеет лимита по количеству машин.
    var showroomCars: [Car] { get set } // машины, находящиеся в автосалоне. Надо ли учесть лимит showroomCapacity?
    var cars: [Car] { get set } // хранит список всех машин в наличии

    func offerAccessories(_ : [String]) // как жаль, что массив тут жёстко определён условием задачи. Лучше бы сразу Set.
    func presaleService(_ : inout Car) // принимает машину в качестве параметра. Метод отправляет машину на предпродажную подготовку.
    func addToShowroom(_ : inout Car) // принимает машину в качестве параметра. Метод перегоняет машину с парковки склада в автосалон, при этом выполняет предпродажную подготовку.
    func sellCar(_ : inout Car) // принимает машину в качестве параметра. Метод продает машину из автосалона при этом проверяет, выполнена ли предпродажная подготовка. Также, если у машины отсутсвует доп. оборудование, нужно предложить клиенту его купить. (давайте представим, что клиент всегда соглашается и покупает :) )
    func orderCar() // не принимает и не возвращает параметры. Метод делает заказ новой машины с завода, т.е. добавляет машину на парковку склада.

    // вспомогательные методы
    func availabilityCheck(color: Palette) -> Car?
}

// MARK: - Часть 3.

// ! Используя структуры...
struct BrandCar: Car {

    var vin: UUID
    var brand: CarBrands
    var color: Palette
    var buildDate: Date
    var price: UInt32
    var accessories: Set<String>
    var isServiced: Bool = false

    mutating func buyingAccessories() {
        accessories = allAccessories // Купить всё
    }
}

// ! создайте несколько машин разных марок (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Car'.
// Создаём завод по производству автомобилей
protocol CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar
}

struct BmwFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        // в четвёртой части понадобятся прошлогодние автомобили
        var date = Calendar.current.date(byAdding: .year, value: Int.random(in: -1...0), to: Date())!
        return BrandCar(vin: UUID.init(), brand: .BMW, color: color, buildDate: date, price: 20_000, accessories: ["toning", "signaling", "sportsDiscs"])
    }
}
struct HondaFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        var date = Calendar.current.date(byAdding: .year, value: Int.random(in: -1...0), to: Date())!
        return BrandCar(vin: UUID.init(), brand: .Honda, color: color, buildDate: date, price: 15_000, accessories: ["signaling", "sportsDiscs"])
    }
}
struct AudiFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Audi, color: color, buildDate: Date(), price: 19_000, accessories: ["sportsDiscs"])
    }
}
struct LexusFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Lexus, color: color, buildDate: Date(), price: 21_000, accessories: ["toning", "signaling"])
    }
}
struct VolvoFactory: CarMakingDelegate {
    func makeCar(color: Palette) -> BrandCar {
        return BrandCar(vin: UUID.init(), brand: .Volvo, color: color, buildDate: Date(), price: 21_000, accessories: ["signaling"])
    }
}

// А вот и сами заводы
var factories: [CarBrands : CarMakingDelegate] = [.BMW   : BmwFactory(),
                                                  .Honda : HondaFactory(),
                                                  .Audi  : AudiFactory(),
                                                  .Lexus : LexusFactory(),
                                                  .Volvo : VolvoFactory()]

// Да, трейдеры они такие. Скупают всё. Потом по салонам развезут.
struct Trader {

    var factory: CarMakingDelegate?
    var cars = [UUID : Car]()

    mutating func orderCar(facroty: CarMakingDelegate, color: Palette) {
        self.factory = facroty
        let newCar = facroty.makeCar(color: color)
        self.cars[newCar.vin] = newCar
    }
}

// Тредер делат заказ автомобилей на всех заводах.
var trader = Trader()
CarBrands.allCases.forEach { brand in
    for _ in 1...countCarsInFactory[brand]! {
        if let color = Palette.allCases.randomElement() {
            if let factory = factories[brand] {
                trader.orderCar(facroty: factory, color: color)
            } else {
                print("Нет фабрики для бренда: ", brand)
            }
        }
    }
}
print("Количество автомобилей всех марок заказанных трейдером: ", trader.cars.count )


// ! Используя классы
// ! Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.
// а это значит от нас требуется сделать на каждый диллерский центр свой класс.
// 1. общий класс для всех
class DealershipSalon: Dealership {

    var name: CarBrands
    var showroomCapacity: UInt16 // максимальная вместимость автосалона по количеству машин
    var stockCars: [Car] = [] // машины, находящиеся на парковке склада. парковка не имеет лимита по количеству машин.
    var showroomCars: [Car] = [] // машины, находящиеся в автосалоне. Учесть лимит showroomCapacity
    var cars: [Car] = [] // хранит список всех машин в наличии
    var factory: CarMakingDelegate?
    private var sellColor: Palette = .red // ну уж очень устал, чтобы делать опционал. Сорри. Это не на что не влияет, т.к. будет использоваться после продажи.

    init(name: CarBrands, showroomCapacity: UInt16) {
        self.name = name
        self.showroomCapacity = showroomCapacity
    }

    func availabilityCheck(color: Palette) -> Car? {
        return cars.first(where: {$0.color == color})
    }

    func offerAccessories(_ accessories: [String]) {
        guard !accessories.isEmpty else {
            print("Задайте список возможных аксессуаров")
            return
        }
        let requestedAccessories = Set(accessories)
        let defunctAccessories = requestedAccessories.subtracting(allAccessories) // вычетание
        if defunctAccessories.count > 0 {
            print("\tЭтих аксессуаров несуществует:")
            defunctAccessories.map{ print("- ",$0) }
        }
        var selectedAccessories = requestedAccessories.intersection(allAccessories) // Пересечение
        if selectedAccessories.count > 0 {
            print("\tПредалагаем купить следующие аксессары:")
            selectedAccessories.forEach{ print("- ", $0) }
        } else {
            print("Не задано ни одного существующего аксессуара")
        }
    }

    func presaleService(_ car: inout Car) {
        guard !car.isServiced else {
            print("Предпродажная подготовка не требуется")
            return
        }
        print("\tНа предпродажную подготовку поступил автомобиль", car.brand, car.color)
        car.isServiced = true
        print("Предпродажная подготовка произведена")
    }

    func addToShowroom(_ car: inout Car) {
        print("\tПоступил запрос на перегон с парковки склада в автосалон автомобиля: ", car.brand, car.color)
        guard stockCars.contains(where: {$0.color == car.color}) else {
            print("На парковке салона такого автомобиля нет")
            return
        }
        showroomCars.append(car)
        stockCars.removeAll(where: {$0.color == car.color})
        print("Автомобиль переставлен в салон")

        presaleService(&car)
    }

    func sellCar(_ car: inout Car) {
        // если автомобиля вообще нет в салоне, то проверки сюда не попасть. Проверка перед вызовом.
        print("\tПродаём автомобиль", car.brand, car.color)
        if showroomCars.first(where: {$0.color == car.color}) == nil {
            print("Машины в салне нет. Забираем её со стоянки.") // вариант, что машина в салоне есть, а её нет ни салоне, ни на парковке не должен случаться вообще.
            if showroomCars.count >= showroomCapacity {
                print("Салон переполнен! Перегоняем первую машину из салона на парковку")
                stockCars.append(showroomCars.removeFirst())
            }
            addToShowroom(&car)
        }
        // теперь автомобиль точно есть в салоне

        // по условию задачи проверяем предпродажную подготовку, хотя как машина пападёт в салон без неё?
        presaleService(&car)

        // формируем список нехватающих допов // allAccessories vs. car.accessories
        let carAccessories = Set(car.accessories) // Если допов не было изначально, то пустое множество -- не проблема.
        let newAccessories = allAccessories.subtracting(Set(car.accessories)) // это причина выбора множества.
        if newAccessories.count > 0 {

            offerAccessories(Array(newAccessories)) // гоняем Set - Array только из-за жёских условий задачи. Хотелось бы только на Сетах всё сделать.

            // покупаем все предложенное
            car.buyingAccessories()
        } else {
            print("Аксессуаров уже под завязку. Больше ничего предложить не можем.")
        }

        // удаяем машину из салона (на стоянке её ведь быть уже не может) и из общего списка
        self.sellColor = car.color
        showroomCars.removeAll(where: {$0.color == car.color})
        cars.removeAll(where: {$0.color == car.color})
        print("\tПродано!")

        orderCar()
    }

    func orderCar() {
        print("Салон \(name) заказывает себе новый автомобиль цвета \(sellColor)...")
        guard let newCar = factory?.makeCar(color: sellColor) else {
            print("Не удалость заказать автомобиль \(name) цвета \(sellColor) в салон")
            return
        }
        stockCars.append(newCar)
        cars.append(newCar)
        print("Автомобиль успешно заказан на заводе \(factory!)")
    }
}

// 2. классы диллерских центров по брендам
final class DealershipSalonBMW: DealershipSalon {

    let slogan = "Freude am Fahren" // С удовольствием за рулём

    init(factory: CarMakingDelegate) {
        super.init(name: .BMW, showroomCapacity: 100)
        self.factory = factory
    }
}
final class DealershipSalonHonda: DealershipSalon {

    let slogan = "자동차에서 삶의 동반자로" // Сначала человек, потом машина

    init(factory: CarMakingDelegate) {
        super.init(name: .Honda, showroomCapacity: 200)
        self.factory = factory
    }
}
final class DealershipSalonAudi: DealershipSalon {

    let slogan = "Vorsprung durch Technik" // Превосходство технологий

    init(factory: CarMakingDelegate) {
        super.init(name: .Audi, showroomCapacity: 90)
        self.factory = factory
    }
}
final class DealershipSalonLexus: DealershipSalon {

    let slogan = "Lexus. Experience Amazing."

    init(factory: CarMakingDelegate) {
        super.init(name: .Lexus, showroomCapacity: 80)
        self.factory = factory
    }
}
final class DealershipSalonVolvo: DealershipSalon {

    let slogan = "Volvo. For life"

    init(factory: CarMakingDelegate) {
        super.init(name: .Volvo, showroomCapacity: 70)
        self.factory = factory
    }
}

// ! создайте пять различных дилерских центров (например BMW, Honda, Audi, Lexus, Volvo). Все они должны реализовать протокол 'Dealership'.
// протокол реализуется через класс. Сложим все диллерские центры (салоны) в словарь для дальнейшего удобства.
var dealershipBrands = [CarBrands : DealershipSalon]()
dealershipBrands[.BMW] = DealershipSalonBMW(factory: factories[.BMW]!)
dealershipBrands[.Honda] = DealershipSalonHonda(factory: factories[.Honda]!)
dealershipBrands[.Audi] = DealershipSalonAudi(factory: factories[.Audi]!)
dealershipBrands[.Lexus] = DealershipSalonLexus(factory: factories[.Lexus]!)
dealershipBrands[.Volvo] = DealershipSalonVolvo(factory: factories[.Volvo]!)

// ! Каждому дилерскому центру добавьте машин на парковку и в автосалон (используйте те машины, которые создали ранее).
// Автосалон при получении автомобиля назначает ему стоимость и даёт от 1 до 3 аксессуара на удачу. Если случайная величина совпадёт, то будет менее трёх аксессуаров.

// Трейдер раставляет автомобили по салонам
for (vin, car) in trader.cars {
    if let salon = dealershipBrands[car.brand] {
        salon.cars.append(car)
        // ставим автомобили в салон по цвету, но не более, чем мест в салоне.
        if car.color == Palette.allCases.randomElement()  &&  salon.showroomCars.count < salon.showroomCapacity {
            salon.showroomCars.append(car)
        } else {
            salon.stockCars.append(car)
        }
        trader.cars[vin] = nil // просто перестаить экземпляр структуры не знаю как. Получается делаем копию в салон, а потом удаляем у трейдера.
    } else {
        print("Для марки \(car.brand) не нашлось салона")
    }
}
dealershipBrands.forEach { (brand: CarBrands, salon: DealershipSalon) in
    print("Количество автомобилей переданнх в диллерский центр \(brand)): ", salon.cars.count)
}
print("Количество автомоблией оставшихся у трейдера: ", trader.cars.count)

// Пришёл покупатель за чёрным бумером, а такой цвет отсутствует в списке цветов у менеджера и даже проверок делать не надо.
print("\n\nПокупатель пришёлв свлон БМВ за красной машиной.")
// Покупатель в салоне, значит он точно есть!
var brand = CarBrands.BMW
var salon = dealershipBrands[brand]!
var color = Palette.red
var car = salon.availabilityCheck(color: color)
if car == nil {
    print("Извините, в салоне нет машины цвета: ", color)
} else {
    salon.sellCar(&car!)
}
print(line)
print("В салон Вольво пришёл покупатель на синей машиной.")
brand = CarBrands.Volvo
salon = dealershipBrands[brand]!
color = Palette.blue
car = salon.availabilityCheck(color: color)
if car == nil {
    print("Извините, в салоне нет машины цвета: ", color)
} else {
    salon.sellCar(&car!)
}

// ! Создайте массив, положите в него созданные дилерские центры.
// из словаря массив :)
var dealerships = [Dealership]()
dealershipBrands.forEach { (_, salon: DealershipSalon) in
    dealerships += [salon]
}

// ! Пройдитесь по нему циклом и выведите в консоль слоган для каждого дилеского центра (слоган можно загуглить).
// ! Обратите внимание! Используйте конструкцию приведения типа данных для решения этой задачи.
// Dealerships[0].slogan -- у суперкласса нет слогана, поэтому идём на ступень ниже:
print("\n", line, "Слоганы автосалонов:")
dealerships.forEach {
    if let salon = $0 as? DealershipSalonBMW {
        print($0.name, "-", salon.slogan)
    } else if let salon = $0 as? DealershipSalonHonda {
        print($0.name, "-", salon.slogan)
    } else if let salon = $0 as? DealershipSalonAudi {
        print($0.name, "-", salon.slogan)
    } else if let salon = $0 as? DealershipSalonLexus {
        print($0.name, "-", salon.slogan)
    } else if let salon = $0 as? DealershipSalonVolvo {
        print($0.name, "-", salon.slogan)
    }
}

print(line)
// MARK: - Часть 4.
/*
 Работа с расширениями. Нам нужно добавить спецпредложение для "прошлогодних" машин.

 Алгоритм выполнения

 Создайте протокол SpecialOffer.
 Добавьте методы:
 - 'addEmergencyPack()': не принимает никаких параметров. Метод добавляет аптечку и огнетушитель к доп. оборудованию машины.
 - 'makeSpecialOffer()': не принимает никаких параметров. Метод проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.

 Используя расширение, реализуйте протокол 'SpecialOffer' для любых трех дилерских центров.
 Проверьте все машины в дилерском центре (склад + автосалон), возможно они нуждаются в специальном предложении. Если есть машины со скидкой на складе, нужно перегнать их в автосалон.
*/

let emergencyPack: Set<String> = ["firstAidKit", "fireExtinguisher"]

protocol SpecialOffer {
    // ! не принимает никаких параметров
    // ! добавляет аптечку и огнетушитель к доп. оборудованию машины.
    func addEmergencyPack(_ : inout Car)
    // ! не принимает никаких параметров
    // ! проверяет дату выпуска авто, если год выпуска машины меньше текущего, нужно сделать скидку 15%, а также добавить аптеку и огнетушитель.
    func makeSpecialOffer()
}
// ! Используя расширение, реализуйте протокол 'SpecialOffer' для любых трех дилерских центров.
extension DealershipSalonBMW: SpecialOffer{
    func addEmergencyPack(_ car: inout Car) {
        print("Adding emergecy pack", emergencyPack)
        car.accessories = car.accessories.union(emergencyPack)
        print("А ещё мы бесплатно добавили пакет безопасности! Вот:", car.accessories)
    }
    func makeSpecialOffer() {
        print("SpecialOffer")
        for var car in cars {
            // print(car)
            let date = Date()
            if car.buildDate.formatted(.dateTime.year()) != date.formatted(.dateTime.year()) {
                print("Найден автомобиль с годом выпуска машины меньше текущего: ", car.buildDate)
                print("Его стараня цена: ", car.price)
                car.price = UInt32(Double(car.price) * 0.85)
                print("Его новыя цена: ", car.price)
                addEmergencyPack(&car)

                // ! Если есть машины со скидкой на складе, нужно перегнать их в автосалон.
                if salon.stockCars.first(where: {$0.color == car.color}) != nil {
                if salon.stockCars.first(where: {$0.color == car.color}) != nil {
                    print("Машина на паркове склада. Забираем её со стоянки.")
                    //        if showroomCars.count >= showroomCapacity {
                    //            print("Салон переполнен! Перегоняем первую машину из салона на парковку")
                    //            stockCars.append(showroomCars.removeFirst())
                    //        }
                    //        addToShowroom(&car)
                    //    }
                    //    // теперь автомобиль точно есть в салоне
                }
            }
        }
    }
}
extension DealershipSalonHonda: SpecialOffer{
    func addEmergencyPack(_: inout Car) {
        print("Adding emergecy pack", emergencyPack)
    }

    func makeSpecialOffer() {
        print("SpecialOffer")
    }
}
extension DealershipSalonVolvo: SpecialOffer{
    func addEmergencyPack(_: inout Car) {
        print("Adding emergecy pack", emergencyPack)
    }

    func makeSpecialOffer() {
        print("SpecialOffer")
    }
}

// ! Проверьте все машины в дилерском центре (склад + автосалон), возможно они нуждаются в специальном предложении.
for (_, dealership) in dealershipBrands {
    if let salon = dealership as? DealershipSalonBMW {
        salon.makeSpecialOffer()
    } else if let salon = dealership as? DealershipSalonHonda {
        salon.makeSpecialOffer()
    } else if let salon = dealership as? DealershipSalonVolvo {
        salon.makeSpecialOffer()
    }
}

//for (vin, brand1, color1, buildDate, price, accessories) in salon.stockCars {

//dealershipBrands.forEach { (brand: Ca, salon: DealershipSalon) in
//    dealerships += [salon]

//func addToShowroom(_ car: inout Car) {
//    print("\tПоступил запрос на перегон с парковки склада в автосалон автомобиля: ", car.brand, car.color)
//    guard stockCars.contains(where: {$0.color == car.color}) else {
//        print("На парковке салона такого автомобиля нет")
//        return
//    }
//    showroomCars.append(car)
//    stockCars.removeAll(where: {$0.color == car.color})
//    print("Автомобиль переставлен в салон")
//
//    presaleService(&car)
//}
//
//func sellCar(_ car: inout Car) {
//    if showroomCars.first(where: {$0.color == car.color}) == nil {
//        print("Машины в салне нет. Забираем её со стоянки.") // вариант, что машина в салоне есть, а её нет ни салоне, ни на парковке не должен случаться вообще.
//        if showroomCars.count >= showroomCapacity {
//            print("Салон переполнен! Перегоняем первую машину из салона на парковку")
//            stockCars.append(showroomCars.removeFirst())
//        }
//        addToShowroom(&car)
//    }
//    // теперь автомобиль точно есть в салоне
