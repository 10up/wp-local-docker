import test from 'ava';

test('Test', t => {
  t.true(true, 'sample assertion');
});

test('Async test', async t => {
  const value = await true;
  t.true(value, 'sample assertion');
});
