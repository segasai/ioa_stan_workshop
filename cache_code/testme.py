from cached import stan_cache
model_code = '''
data {
  int x ; 
}
parameters
{
  real alpha;
}
model{
  x ~ poisson(alpha);
}
'''

# with same model_code as before
data = dict(x=3)
sm = stan_cache(model_code=model_code)
fit = sm.sampling( data=data)
print(fit)

