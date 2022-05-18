/*
Author Information:
 Group Name: Group Project - Stanley Chong, Lauren Moon
 Name:       Lauren Moon, Stanley Chong
 Email:      lrn.moon1@csu.fullerton.edu, stanley54073@csu.fullerton.edu

 This program is free software: you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation, either version 3 of the License, or (at your option) any later
 version.This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 details.You should have received a copy of the GNU General Public License
 along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class Calculator; }
QT_END_NAMESPACE

class Calculator : public QMainWindow
{
    Q_OBJECT

public:
    Calculator(QWidget *parent = nullptr);
    ~Calculator();

    enum Operation
    {
        None = 0,
        Add = 1,
        Subtract = 2,
        Multiply = 3,
        Divide = 4,
        Factorial = 5,
        Sin = 6,
        Cos = 7,
        Tan = 8,
        Sqrt = 9,
        Sqrd = 10,
        Power = 11,
        Derivative = 12,
    };

private slots:
    void on_button_0_clicked();
    void on_button_1_clicked();
    void on_button_2_clicked();
    void on_button_3_clicked();
    void on_button_4_clicked();
    void on_button_5_clicked();
    void on_button_6_clicked();
    void on_button_7_clicked();
    void on_button_8_clicked();
    void on_button_9_clicked();

    void on_button_clear_clicked();
    void on_button_pos_neg_clicked();
    void on_button_plus_clicked();
    void on_button_minus_clicked();
    void on_button_multiply_clicked();
    void on_button_divide_clicked();
    void on_button_sin_clicked();
    void on_button_cos_clicked();
    void on_button_tan_clicked();
    void on_button_derivatives_clicked();
    void on_button_integral_clicked();
    void on_button_factorial_clicked();
    void on_button_sqroot_clicked();
    void on_button_x_y_power_clicked();
    void on_button_xsquared_clicked();
    void on_button_x_clicked();
    void on_button_equals_clicked();

    void on_button_decimal_clicked();

private:
    void StartNewValue();
    int CalcFactorial();
    void SavePolynomial();
    void CalculateDerivative();

private:
    Ui::Calculator *ui;
    double m_value = 0;
    double m_savedNumber = 0;
    std::string m_polynomial;
    bool m_startingNewValue = false;
    bool m_startingDerivative = false;

    Operation m_currentOperation = Operation::None;



};
#endif // CALCULATOR_H
