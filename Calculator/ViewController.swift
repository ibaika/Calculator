import UIKit

class ViewController: UIViewController {
    
    //Коллекция из 5 кнопок операций
    @IBOutlet var operationButtons: [UIButton]!
    
    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var clearButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    var firstNumber: String = ""
    var operation: String = ""
    var secondNumber: String = ""
    var currentNumber: String = ""
    
    var currentResult: Int = 0
    
    typealias OperationData = (Int, String)
    var latestOperation: OperationData = (0, "")
    
    //Сброс цветов по умолчанию для оранжевых кнопок с белым текстом.
    func resetAllOperationButtons(){
        for operationButton in operationButtons{
            operationButton.backgroundColor = UIColor.orange
            operationButton.tintColor = UIColor.white
        }
    }
    
    
    
    //Смена цвета у нажатой оранжевой кнопки.
    func drawButtonWhenTapped(sender: UIButton){
        sender.backgroundColor = UIColor.white
        sender.tintColor = UIColor.orange
    }
    
    //MARK: defineOperation()
    //Функция определения, какая операция запрашивается
    func defineOperation(_ operationButtonNumber: Int){
        switch operationButtonNumber{
        case 13: operation = "÷"
        case 14: operation = "✕"
        case 15: operation = "-"
        case 16: operation = "+"
        default: print("not found operation")
        }
    }
    
    
    //Проверка, начинается ли число с 0, чтоб предотвратить появление чисел типа 001/010 и т.д.
    func numberStartsWithZero(number: String) -> Bool {number.prefix(1) == "0"}

    //Проверка, первое ли число вводится. Число является первым, если еще не присвоено значение операции.
    func isFirstNumber() -> Bool {operation.isEmpty}
    
    
    //Функция, проверяющаяя, если число и есть результат. (После нажатия на кнопку "=").
    func numberBeenChanged(number: String) -> Bool { number != ""  && Int(number) == currentResult}
    
    //Функция, проверяющая, целое ли число.
    
    func isWholeNumber(number: String) -> Bool { Double(number)?.truncatingRemainder(dividingBy: 1) == 0}
      
      
    //MARK: showNumber(number: String)
    //Функция, присваювающая тексту на экране число.
    func showNumber(number: String) {
        currentNumber = number
        resultLabel.text = number
    }
      
    
    //Функция нажатия на кнопку операции
    @IBAction func operationButtonTapped(_ sender: UIButton) {
        
        var result: Int = 0
        
        resetAllOperationButtons()
    
        drawButtonWhenTapped(sender: sender)
        
        if (secondNumber.isEmpty && operation.isEmpty) || (!operation.isEmpty && secondNumber.isEmpty){
            defineOperation(sender.tag)
        }
    
        else if !operation.isEmpty && !secondNumber.isEmpty{
            result = findResult(firstNumber, secondNumber, operation)
            firstNumber = "\(result)"
            
        
            showNumber(number: firstNumber)
            defineOperation(sender.tag)
            secondNumber = ""
            }
        
        
        print("First number is \(firstNumber)")
        print("Operation is \(operation)")
        print("Second number is \(secondNumber)")
        print("Current number is \(currentNumber)")
        
    }
        
   
    func setNumberValue(number: String, buttonNumber: Int) -> String{
        var number: String = "0"
        switch buttonNumber{
        case 0: number = "0"
        case 1: number = "1"
        case 2: number = "2"
        case 3: number = "3"
        case 4: number = "4"
        case 5: number = "5"
        case 6: number = "6"
        case 7: number = "7"
        case 8: number = "8"
        case 9: number = "9"
        default: print("something unexpected happened when trying to give value to numbers")
        }
        return number
    }
    
    @IBAction func numberTapped(_ sender: UIButton) {
        
        if sender.tag != 0 {
            clearButton.setTitle("C", for: .normal)
        }
        
        if numberBeenChanged(number: firstNumber){
            
            resetAllOperationButtons()
            firstNumber = setNumberValue(number: firstNumber, buttonNumber: sender.tag)
            showNumber(number: firstNumber)
        }
        

        
        else if isFirstNumber(){
            
            //Если число начинается с нуля, то есть если число ноль
            if numberStartsWithZero(number: firstNumber){
                firstNumber = setNumberValue(number: firstNumber, buttonNumber: sender.tag)
                showNumber(number: firstNumber)
            }  else {
                firstNumber += setNumberValue(number: firstNumber, buttonNumber: sender.tag)
                showNumber(number: firstNumber)
            }
          
        }
        
        //Для второго числа
        else {
            
            //Покрасить кнопку операции в дефолтный цвет
            resetAllOperationButtons()
            
            //Если число начинается с нуля, то есть если число ноль
            if numberStartsWithZero(number: secondNumber){
                secondNumber = setNumberValue(number: secondNumber, buttonNumber: sender.tag)
                showNumber(number: secondNumber)
            } else {
                secondNumber += setNumberValue(number: secondNumber, buttonNumber: sender.tag)
                showNumber(number: secondNumber)
            }
        }
    }
    
    //MARK: isDividorZero()
    
    func isDividorZero(dividor: Int) -> Bool{ dividor == 0 }
    
    
    //MARK: findResult()
    func findResult(_ firstNum: String,_ secondNum: String, _ operation: String) -> Int{
        
        var result: Int = 0
        
        let a = Int(firstNum) ?? 0
        print(firstNum)
        
        //Если оба числа имеют значения (если это не повторное нажатие на знак =)
        if let b = Int(secondNum){
            
            //Если допустимое деление
            if operation == "÷" && b != 0 {
                result = a / b
                firstNumber = "\(result)"
                showNumber(number: firstNumber)

            }
            
            //Если допустимая операция
            else if b != 0 {
                switch operation{
                case "÷":
                    result = a / b
                case "✕":
                    result = a * b
                case "-":
                    result = a - b
                case "+":
                    result = a + b
                default: print("No found operation. Why?")
                }
                
                firstNumber = "\(result)"
                showNumber(number: firstNumber)
            }
            
            //Если недопустимое деление
            else {
                resultLabel.text = "Ошибка"
                result = 0
                firstNumber = "\(result)"
                currentNumber = firstNumber
            }
            
            latestOperation = (b, operation)
        }
        
        // Если это повторное нажатие на знак = :
        else  if operation.isEmpty && secondNumber.isEmpty{
            firstNumber = String(currentResult)
            secondNumber = currentNumber
            print("Я захожу сюда. Мои данные входные: ")
            print("Первое число: \(firstNumber)")
            print("Операция: \(operation)")
            print("Второе число: \(secondNumber)")
            print("Текущее число: \(currentNumber) , \(currentResult)")
            let latestGivenValue: Int = latestOperation.0
            let latestOperation: String = latestOperation.1
            result = Int(firstNumber) ?? 0
            switch latestOperation{
            case "÷":
                
                if isDividorZero(dividor: latestGivenValue){
                    resultLabel.text = "Ошибка"
                    result = 0
                    firstNumber = "\(result)"
                    currentNumber = firstNumber
                } else {
                    result /= latestGivenValue
                }
                
            case "✕": result *= latestGivenValue
            case "-": result -= latestGivenValue
            case "+": result += latestGivenValue
                
            default: print("No latest operation yet! So miss it.")
            }
            
            firstNumber = "\(result)"
            showNumber(number: firstNumber)
        }
        
        else if !operation.isEmpty && secondNumber.isEmpty{
            secondNumber = firstNumber
            firstNumber = "\(currentResult)"
            
            result = Int(secondNumber)! + Int(firstNumber)!
            
            firstNumber = "\(result)"
            currentResult = result
            showNumber(number: firstNumber)
            
            
        }
        
        return result

        }
        
    
    
    @IBAction func showResult(_ sender: UIButton) {
        print("Первое число: \(firstNumber)")
        print("Текущее число: \(currentNumber) , \(currentResult)")
        print("Операция: \(operation)")
        print("Второе число: \(secondNumber)")
        currentResult = findResult(firstNumber, secondNumber, operation)
        firstNumber = "\(currentResult)"
        operation = ""
        secondNumber = ""
        print(latestOperation)
        }
    
    
    
    
    @IBAction func changeNumberSymbol(_ sender: UIButton) {
        
        if var a = Int(firstNumber){
            if a == Int(currentNumber){
                if a > 0{
                    a *= -1
                    firstNumber = "\(a)"
                } else {
                    firstNumber = "\(abs(a))"
                }
                showNumber(number: firstNumber)
            }
        }
        
        
        if var b = Int(secondNumber){
            if b == Int(currentNumber){
                if b > 0{
                    b *= -1
                    secondNumber = "\(b)"
                } else{
                    secondNumber = "\(abs(b))"
                }
                showNumber(number: secondNumber)
            }
        }
        
    }
    
    
    
    @IBAction func percentNumber(_ sender: UIButton) {
        if var a = Int(firstNumber){
            if a == Int(currentNumber){
                a = a / 100
                firstNumber = "\(a)"
                showNumber(number: firstNumber)
            }
        }
        
        if var b = Int(secondNumber){
            if b == Int(currentNumber){
                b = b / 100
                secondNumber = "\(b)"
                showNumber(number: secondNumber)
            }
        }
    }
    
    
    
    @IBAction func resetAll(_ sender: UIButton) {
        clearButton.setTitle("AC", for: .normal)
        resetAllOperationButtons()
        firstNumber = "0"
        secondNumber = ""
        operation = ""
        resultLabel.text = "0"
        currentNumber = ""
        latestOperation = (0, "")
    }
}


//разбить функцию findResult на несколько мелких

//разрядность:
//  если цифр 4, то после 1 цифры ( 1,000)
//  если цифр 5, то после 2 цифры ( 11,000)
//  если цифр 6, то после 3 цифры ( 110,000)
//  если цифр 7, то после 1 и 4 цифры ( 1,110,000)
//  если цифр 8, то после 2 и 5 цифры ( 11,111,000)
//  если цифр 9, то после 3 и 6 цифры ( 111,111,000)

//максимум символов сделать: 11.
//из них 9 цифр



//попробовать сделать, что если рез-т "Ошибка", то любое дальнейшее действие – ошибка

//добавить точку
//сделать дробные вычисления
//определять, целое ли число или нет для показа в ответе


//оптимизировать код




