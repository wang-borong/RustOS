#![no_std]
#![no_main]
#![feature(asm)]
#![feature(global_asm)]
#![feature(panic_info_message)]

#[macro_use]
mod console;
mod panic;
mod sbi;

global_asm!(include_str!("entry.S"));

#[no_mangle]
pub extern "C" fn rust_main() -> ! {
    println!("hello world");
    panic!("panic and shutdown!")
}
