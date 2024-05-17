set Products;
set StorageGroups;
set StorageGroupAssignments within {StorageGroups, Products};
set Machines;
param n_months;
set Months = {1..n_months};
param n_scenarios;
set Scenarios = {1..n_scenarios};

param machine_count {Machines};
param unit_production_time {Machines, Products} default 0;
param revenue {Products, Scenarios};
param max_sale {Products, Months};
param storage_unit_cost_per_month;
param max_storage_in_month;
param initial_stored_products {Products};
param work_hours_in_month;

param rho;
param lambda_risk;
param lambda_profit;
param a_risk;
param a_profit;

var sale {p in Products, n in Months} >= 0, <= max_sale[p,n], integer;
var production {p in Products, n in Months} >= 0, integer;
var storage {p in Products, n in {0} union Months} >= 0, integer;
var storage_group_chosen {g in StorageGroups, n in Months} binary;
var risk_plus {Scenarios} >= 0;
var risk_minus {Scenarios} >= 0;
var risk {s in Scenarios} = risk_plus[s] - risk_minus[s];
var risk_average = sum {s in Scenarios} (risk_plus[s] + risk_minus[s]) / n_scenarios;

var profit {s in Scenarios} =
  sum {p in Products, n in Months} (
    sale[p,n] * revenue[p,s] - storage[p,n] * storage_unit_cost_per_month
  );
var profit_average = sum{s in Scenarios} profit[s] / n_scenarios;

var min_target;

s.t. machine_usage_time_limit {m in Machines, n in Months}:
  sum {p in Products} production[p,n] * unit_production_time[m,p]
  <= work_hours_in_month * machine_count[m];

s.t. initial_storage {p in Products}:
  storage[p,0] = initial_stored_products[p];

s.t. one_storage_group_chosen_per_month {n in Months}:
  sum {g in StorageGroups} storage_group_chosen[g,n] <= 1;

s.t. products_stored_only_from_chosen_storage_group {n in Months, g in StorageGroups}:
  sum {(gg,p) in StorageGroupAssignments : gg = g} storage[p,n]
  <= max_storage_in_month * storage_group_chosen[g,n];

s.t. ampere_law_for_products {n in Months, p in Products}:
  production[p,n] + storage[p,n-1] = sale[p,n] + storage[p,n];

s.t. risk_calculate {s in Scenarios}:
  risk[s] = (profit_average - profit[s]);

s.t. min_target_risk:
  min_target <= lambda_risk * (a_risk - risk_average);
s.t. min_target_profit:
  min_target <= lambda_profit * (profit_average - a_profit);

maximize maximize_min_target_then_all_targets:
  min_target + rho * (
    lambda_risk * (a_risk - risk_average)
    + lambda_profit * (profit_average - a_profit)
  );
