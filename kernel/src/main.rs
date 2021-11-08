#![no_std]
#![no_main]
#![feature(asm)]
#![feature(global_asm)]

global_asm!(include_str!("entry.S"));

use core::panic::PanicInfo;

/// 这个函数将在panic时被调用
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

pub fn console_putchar(ch: u8) {
    let _ret: usize;
    let arg0: usize = ch as usize;
    let arg1: usize = 0;
    let arg2: usize = 0;
    let which: usize = 1;
    unsafe {
        asm!("ecall",
            lateout("x10") _ret,
            in("x10") arg0,
            in("x11") arg1,
            in("x12") arg2,
            in("x17") which
        );
    }
}

#[no_mangle]
pub extern "C" fn rust_main() -> ! {
    console_putchar(b'O');
    console_putchar(b'K');
    console_putchar(b'\n');
    loop {}
}
