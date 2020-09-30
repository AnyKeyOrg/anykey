/*
 * Sets up serverless Stripe
 * checkout buttons for Donate page
 */

$(document).ready(function() {
  var stripe = Stripe('pk_live_51HV8FHBQehflyhkgxv9mJo62lHAuTHiraarOvNo2h6cy9doKwLXHLqqFVk6gWYI0EZFOHVyFgo2yAZ9PL07n7ALh00XxiCdlG7');

  var checkoutButton1 = document.getElementById('checkout-button-price_1HXAc8BQehflyhkgOufcv8SR');
  if (checkoutButton1)
    checkoutButton1.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAc8BQehflyhkgOufcv8SR', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton5 = document.getElementById('checkout-button-price_1HXAcFBQehflyhkgnMg71AhB');
  if (checkoutButton5)
    checkoutButton5.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAcFBQehflyhkgnMg71AhB', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton10 = document.getElementById('checkout-button-price_1HXAcMBQehflyhkgjycShX8z');
  if (checkoutButton10)
    checkoutButton10.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAcMBQehflyhkgjycShX8z', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton25 = document.getElementById('checkout-button-price_1HXAcSBQehflyhkg7AQ7M90I');
  if (checkoutButton25)
    checkoutButton25.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAcSBQehflyhkg7AQ7M90I', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton50 = document.getElementById('checkout-button-price_1HXAcYBQehflyhkgad1lX1fs');
  if (checkoutButton50)
    checkoutButton50.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAcYBQehflyhkgad1lX1fs', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton100 = document.getElementById('checkout-button-price_1HXAcdBQehflyhkgvQF3bG9e');
  if (checkoutButton100)
    checkoutButton100.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAcdBQehflyhkgvQF3bG9e', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

  var checkoutButton500 = document.getElementById('checkout-button-price_1HXAchBQehflyhkglDAHzzPI');
  if (checkoutButton500)
    checkoutButton500.addEventListener('click', function () {
      stripe.redirectToCheckout({
        lineItems: [{price: 'price_1HXAchBQehflyhkglDAHzzPI', quantity: 1}],
        mode: 'payment',
        successUrl: 'https://anykey.org/donate/success',
        cancelUrl: 'https://anykey.org/donate',
      })
    });

});