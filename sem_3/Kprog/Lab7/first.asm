; Программа для автоматической блокировки экрана
org 100h

; Переменные
user_inactivity_time db 0
threshold db 5 ; Порог неактивности (число "потерянных" секунд)
password db '1234', 0 ; Пароль
input_password db 5 dup(0) ; Буфер для ввода пароля
log_file db 'log.txt', 0 ; Файл для логирования
block_msg db 'Экран заблокирован. Введите пароль: $'
unlock_msg db 'Экран разблокирован!$'
fail_msg db 'Неудачная попытка. Логирование...$'

; Начало программы
start:
    ; Установка обработчика прерывания таймера
    mov ax, 252h
    int 21h
    
    ; Основной цикл
main_loop:
    call CheckUserActivity
    cmp user_inactivity_time, threshold
    jl main_loop

    ; Блокировка экрана
    call LockScreen
    call WaitForPassword
    jmp main_loop

; Проверка активности пользователя
CheckUserActivity:
    ; Здесь должна быть логика проверки активности
    ; Для простоты предполагаем, что пользователь активен, если нажата клавиша
    ; Обрабатываем прерывание клавиатуры
    mov ah, 01h
    int 16h
    jz active ; Если клавиша не нажата, считаем активность потерянной
    jmp check_end

active:
    mov user_inactivity_time, 0 ; Сброс времени неактивности
    jmp check_end

check_end:
    ; Задержка для имитации времени
    mov cx, 0FFFFh
delay:
    loop delay
    inc user_inactivity_time ; Увеличиваем счетчик неактивности
    ret

; Блокировка экрана
LockScreen:
    ; Вывод сообщения о блокировке
    mov dx, offset block_msg
    mov ah, 09h
    int 21h
    ; Здесь можно добавить код для воспроизведения аудио или анимации
    ret

; Ожидание ввода пароля
WaitForPassword:
    ; Сброс буфера
    lea dx, input_password
    mov ah, 0Ah
    int 21h ; Ввод строки
    ; Проверка пароля
    lea dx, input_password
    mov si, offset password
    mov di, offset input_password + 1 ; Пропускаем первый байт (длина)
    
check_password:
    lodsb ; Загружаем байт из пароля
    cmp al, [di] ; Сравниваем с введенным
    je next_char
    jmp LogFailedAttempt

next_char:
    cmp al, 0 ; Проверяем конец строки
    jne check_password
    call UnlockScreen
    ret

; Разблокировка экрана
UnlockScreen:
    ; Вывод сообщения о разблокировке
    mov dx, offset unlock_msg
    mov ah, 09h
    int 21h
    ; Сброс времени неактивности
    mov user_inactivity_time, 0
    ret

; Логирование неудачных попыток
LogFailedAttempt:
    ; Вывод сообщения о неудаче
    mov dx, offset fail_msg
    mov ah, 09h
    int 21h
    
    ; Открытие файла для записи
    mov dx, offset log_file
    mov ah, 3Ch
    int 21h
    ; Проверка на ошибку открытия файла
    jc log_error
    
    ; Запись логов
    mov dx, offset fail_msg
    mov ah, 40h ; Запись в файл
    mov cx, 40h ; Длина сообщения
    int 21h

    ; Закрытие файла
    mov ah, 3Eh
    int 21h
    jmp end_log

log_error:
    ; Обработка ошибки открытия файла
    ; Здесь можно добавить код для обработки ошибок

end_log:
    ret

; Конец программы
end start