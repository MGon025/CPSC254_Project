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

#include "calculator.h"
#include "./ui_calculator.h"
#include <QtMath>

Calculator::Calculator(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::Calculator)
{
    ui->setupUi(this);

    ui->results_display->setAlignment(Qt::AlignRight);
    ui->history->setVisible(false);
}

Calculator::~Calculator()
{
    delete ui;
}

void Calculator::on_button_0_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("0");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_1_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("1");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_2_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("2");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_3_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("3");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_4_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("4");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_5_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("5");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_6_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("6");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_7_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("7");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_8_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("8");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_9_clicked()
{
    if (m_startingNewValue)
        StartNewValue();

    ui->results_display->insertPlainText("9");
    m_value = ui->results_display->toPlainText().toDouble();
}

void Calculator::on_button_decimal_clicked()
{
    ui->results_display->insertPlainText(".");
}

void Calculator::on_button_clear_clicked()
{
    m_value = 0;
    m_savedNumber = 0;

    m_currentOperation = Operation::None;

    ui->results_display->clear();
    ui->results_display->setAlignment(Qt::AlignRight);
}

void Calculator::on_button_pos_neg_clicked()
{
    m_value *= -1;

    ui->results_display->clear();
    ui->results_display->setAlignment(Qt::AlignRight);

    ui->results_display->insertPlainText(QString::number(m_value));
}

void Calculator::on_button_plus_clicked()
{
    on_button_equals_clicked();
    m_currentOperation = Operation::Add;
}

void Calculator::on_button_minus_clicked()
 {
    on_button_equals_clicked();
    m_currentOperation = Operation::Subtract;
 }

void Calculator::on_button_multiply_clicked()
{
    on_button_equals_clicked();
    m_currentOperation = Operation::Multiply;
}

void Calculator::on_button_divide_clicked()
{
    on_button_equals_clicked();
    m_currentOperation = Operation::Divide;
}

void Calculator::on_button_sin_clicked()
{
    m_currentOperation = Operation::Sin;
    on_button_equals_clicked();
}

void Calculator::on_button_cos_clicked()
{
    m_currentOperation = Operation::Cos;
    on_button_equals_clicked();
}

void Calculator::on_button_tan_clicked()
{
    m_currentOperation = Operation::Tan;
    on_button_equals_clicked();
}

void Calculator::on_button_derivatives_clicked()
{
    if (!m_startingDerivative)
    {
        SavePolynomial();
        m_currentOperation = Operation::Derivative;
    }
    else
    {
        on_button_equals_clicked();
    }
}

// new function for part 2
void Calculator::on_button_history_clicked()
{
    ui->history->setVisible(!(ui->history->isVisible()));
    if (!(ui->history->isVisible()))
    {
        // do nothing if closing history window
        return;
    }
}

void Calculator::UpdateHistory()
{
    while (!(m_results.empty())) 
    {
        char *hist_str;
        double result = m_results.front();
        m_results.pop();
        double op1 = m_operands.front();
        m_operands.pop();
        double op2 = m_operands.front();
        m_operands.pop();
        Operation opcode = m_operations.front();
        m_operations.pop();
        switch (opcode)
        {
            case Operation::None:
            {
                qInfo("no op. You should not be seeing this.");
                return;
            }
            case Operation::Add:
            {
                asprintf(&hist_str, "%.10g = %.10g + %.10g", result, op1, op2);
                break;
            }
            case Operation::Subtract:
            {
                asprintf(&hist_str, "%.10g = %.10g - %.10g", result, op1, op2);
                break;
            }
            case Operation::Multiply:
            {
                asprintf(&hist_str, "%.10g = %.10g * %.10g", result, op1, op2);
                break;
            }
            case Operation::Divide:
            {
                asprintf(&hist_str, "%.10g = %.10g / %.10g", result, op1, op2);
                break;
            }
            case Operation::Factorial:
            {
                asprintf(&hist_str, "%.10g = !%.10g", result, op1);
                break;
            }
            case Operation::Sin:
            {
                asprintf(&hist_str, "%.10g = sin(%.10g)", result, op1);
                break;
            }
            case Operation::Cos:
            {
                asprintf(&hist_str, "%.10g = cos(%.10g)", result, op1);
                break;
            }
            case Operation::Tan:
            {
                asprintf(&hist_str, "%.10g = tan(%.10g)", result, op1);
                break;
            }
            case Operation::Sqrt:
            {
                asprintf(&hist_str, "%.10g = sqrt(%.10g)", result, op1);
                break;
            }
            case Operation::Sqrd:
            {
                asprintf(&hist_str, "%.10g = sqr(%.10g)", result, op1);
                break;
            }
            case Operation::Power:
            {
                asprintf(&hist_str, "%.10g = pow(%.10g, %.10g)", result, op1, op2);
                break;
            }
            case Operation::Derivative:
            {
                qInfo("Derivatives not supported. You should not be seeing this");
                return;
            }
        }
        ui->history->addItem(hist_str);
        free(hist_str);
    }
}

void Calculator::on_button_factorial_clicked()
{
    m_currentOperation = Operation::Factorial;
    on_button_equals_clicked();
}

void Calculator::on_button_sqroot_clicked()
{
    m_currentOperation = Operation::Sqrt;
    on_button_equals_clicked();
}

void Calculator::on_button_x_y_power_clicked()
{
    ui->results_display->insertPlainText("^");

    if (!ui->results_display->toPlainText().contains("x"))
    {
        on_button_equals_clicked();
        m_currentOperation = Operation::Power;
    }
}

void Calculator::on_button_xsquared_clicked()
{
    m_currentOperation = Operation::Sqrd;
    on_button_equals_clicked();
}

void Calculator::on_button_x_clicked()
{
    ui->results_display->insertPlainText("x");
}

void Calculator::on_button_equals_clicked()
{
    if (m_startingNewValue)
        return;

    switch (m_currentOperation)
    {
        case Operation::None:
        {
            m_savedNumber = m_value;
            m_startingNewValue = true;
            return;
        }
        case Operation::Add:
        {
            m_operands.push(m_savedNumber);
            m_operands.push(m_value);

            m_savedNumber += m_value;
            m_value = m_savedNumber;
            break;
        }
        case Operation::Subtract:
        {
            m_operands.push(m_savedNumber);
            m_operands.push(m_value);

            m_savedNumber -= m_value;
            m_value = m_savedNumber;
            break;
        }
        case Operation::Multiply:
        {
            m_operands.push(m_savedNumber);
            m_operands.push(m_value);

            m_savedNumber *= m_value;
            m_value = m_savedNumber;
            break;
        }
        case Operation::Divide:
        {
            m_operands.push(m_savedNumber);
            m_operands.push(m_value);

            m_savedNumber /= m_value;
            m_value = m_savedNumber;
            break;
        }
        case Operation::Factorial:
        {
            m_operands.push(m_value);
            m_operands.push(m_value);

            m_savedNumber = CalcFactorial();
            m_value = m_savedNumber;
            break;
        }
        case Operation::Sin:
        {
            m_operands.push(m_value);
            m_operands.push(m_value);

            m_savedNumber = qSin(qreal(m_value));
            m_value = m_savedNumber;
            break;
        }
        case Operation::Cos:
        {
            m_operands.push(m_value);
            m_operands.push(m_value);

            m_savedNumber = qCos(qreal(m_value));
            m_value = m_savedNumber;
            break;
        }
        case Operation::Tan:
        {
            m_operands.push(m_value);
            m_operands.push(m_value);

            m_savedNumber = qTan(qreal(m_value));
            m_value = m_savedNumber;
            break;
        }
        case Operation::Sqrt:
        {
            m_operands.push(m_value);
            m_operands.push(m_value);

            m_savedNumber = qSqrt(m_value);
            m_value = m_savedNumber;
            break;
        }
        case Operation::Sqrd:
        {
            m_operands.push(m_value);
            m_operands.push(m_value);

            m_savedNumber = m_value * m_value;
            m_value = m_savedNumber;
            break;
        }
        case Operation::Power:
        {
            m_operands.push(m_savedNumber);
            m_operands.push(m_value);

            m_savedNumber = qPow(m_savedNumber, m_value);
            m_value = m_savedNumber;
            break;
        }
        case Operation::Derivative:
        {
            CalculateDerivative();
            break;
        }
    }

    ui->results_display->clear();
    ui->results_display->setAlignment(Qt::AlignRight);
    ui->results_display->insertPlainText(QString::number(m_value));

    m_results.push(m_value);
    if (m_currentOperation != Operation::Derivative)
    {
        m_operations.push(m_currentOperation);
    }
    UpdateHistory();

    m_startingNewValue = true;
}

void Calculator::StartNewValue()
{
    ui->results_display->clear();
    ui->results_display->setAlignment(Qt::AlignRight);

    m_value = 0;
    m_startingNewValue = false;
}

int Calculator::CalcFactorial()
{
    int fact = 1;

    if (m_value == 0)
        return fact;

    for (int i = 1; i <= m_value; i++)
        fact = fact * i;

    return fact;
}

void Calculator::SavePolynomial()
{
    m_polynomial = ui->results_display->toPlainText().toStdString();
    m_startingDerivative = true;
    m_startingNewValue = true;
}

void Calculator::CalculateDerivative()
{
    std::string delimiter = "x^";

    size_t pos = 0;
    pos = m_polynomial.find(delimiter);
    double coefficient = std::stod(m_polynomial.substr(0, pos));
    double exponent = std::stod(m_polynomial.substr(pos + 2, m_polynomial.length()-1));

    m_savedNumber = (coefficient*exponent)*pow(m_value, exponent-1);
    m_value = m_savedNumber;
    m_startingDerivative = false;
}
