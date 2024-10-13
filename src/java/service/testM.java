/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import java.util.Arrays;
import java.util.Scanner;

/**
 *
 * @author DELL
 */
public class testM {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        // Lấy thông tin từ người dùng
        System.out.print("Nhập số nguyên dương: ");
        int num = scanner.nextInt();
        
        // Tính giai thừa
        System.out.println("Giai thừa của " + num + " là: " + factorial(num));
        
        // Kiểm tra số nguyên tố
        if (isPrime(num)) {
            System.out.println(num + " là số nguyên tố.");
        } else {
            System.out.println(num + " không phải là số nguyên tố.");
        }
        
        // Kiểm tra chuỗi đối xứng
        System.out.print("Nhập chuỗi cần kiểm tra đối xứng: ");
        scanner.nextLine();  // Bỏ qua ký tự xuống dòng sau khi nhập số
        String inputString = scanner.nextLine();
        if (isPalindrome(inputString)) {
            System.out.println(inputString + " là chuỗi đối xứng.");
        } else {
            System.out.println(inputString + " không phải là chuỗi đối xứng.");
        }
        
        // Tính tổng dãy số Fibonacci
        System.out.print("Nhập số lượng số Fibonacci cần tính: ");
        int fibCount = scanner.nextInt();
        System.out.println("Tổng của " + fibCount + " số Fibonacci đầu tiên là: " + fibonacciSum(fibCount));
        
        // Thao tác trên mảng
        System.out.print("Nhập kích thước của mảng: ");
        int size = scanner.nextInt();
        int[] array = new int[size];
        System.out.println("Nhập các phần tử của mảng: ");
        for (int i = 0; i < size; i++) {
            array[i] = scanner.nextInt();
        }
        
        // Tính tổng của các phần tử trong mảng
        System.out.println("Tổng các phần tử trong mảng: " + arraySum(array));
        
        // Sắp xếp mảng và hiển thị
        System.out.println("Mảng sau khi sắp xếp: " + Arrays.toString(bubbleSort(array)));
        
        // Tìm phần tử lớn nhất và nhỏ nhất trong mảng
        System.out.println("Phần tử lớn nhất trong mảng: " + findMax(array));
        System.out.println("Phần tử nhỏ nhất trong mảng: " + findMin(array));
        
        // Đếm số lần xuất hiện của phần tử trong mảng
        System.out.print("Nhập phần tử cần đếm trong mảng: ");
        int element = scanner.nextInt();
        System.out.println("Phần tử " + element + " xuất hiện " + countOccurrences(array, element) + " lần.");
    }
    
    // Hàm tính giai thừa
    public static int factorial(int n) {
        if (n == 0 || n == 1) {
            return 1;
        }
        return n * factorial(n - 1);
    }
    
    // Hàm kiểm tra số nguyên tố
    public static boolean isPrime(int n) {
        if (n <= 1) return false;
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }
        return true;
    }
    
    // Hàm kiểm tra chuỗi đối xứng
    public static boolean isPalindrome(String str) {
        String reversed = new StringBuilder(str).reverse().toString();
        return str.equals(reversed);
    }
    
    // Hàm tính tổng của dãy Fibonacci
    public static int fibonacciSum(int count) {
        int sum = 0;
        int a = 0, b = 1;
        for (int i = 0; i < count; i++) {
            sum += a;
            int next = a + b;
            a = b;
            b = next;
        }
        return sum;
    }
    
    // Hàm tính tổng các phần tử trong mảng
    public static int arraySum(int[] arr) {
        int sum = 0;
        for (int num : arr) {
            sum += num;
        }
        return sum;
    }
    
    // Hàm sắp xếp mảng theo thuật toán Bubble Sort
    public static int[] bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
        return arr;
    }
    
    // Hàm tìm phần tử lớn nhất trong mảng
    public static int findMax(int[] arr) {
        int max = arr[0];
        for (int num : arr) {
            if (num > max) {
                max = num;
            }
        }
        return max;
    }
    
    // Hàm tìm phần tử nhỏ nhất trong mảng
    public static int findMin(int[] arr) {
        int min = arr[0];
        for (int num : arr) {
            if (num < min) {
                min = num;
            }
        }
        return min;
    }
    
    // Hàm đếm số lần xuất hiện của một phần tử trong mảng
    public static int countOccurrences(int[] arr, int element) {
        int count = 0;
        for (int num : arr) {
            if (num == element) {
                count++;
            }
        }
        return count;
    }
}
